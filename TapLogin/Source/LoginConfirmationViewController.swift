//
//  LoginConfirmationViewController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/11/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import BlockUIViewControllerV2
import TapAdditionsKitV2
import TapBrandBookIOSV2
import TapCountriesKitV2
import TapLocalizationV2
import TapLoggerV2
import TapMessagingV2
import Toast_Swift
import UIKit

private enum ResendButtonMode {

    case countdown
    case resendCode
    case sendCompliance
}

/// Login Confirmation View Controller.
public class LoginConfirmationViewController: LoginContentViewController {

    // MARK: - Public -
    // MARK: Methods

    /// Applies confirmation code retreived from deep link.
    ///
    /// - Parameter confirmationCode: Confirmation code to apply.
    public func setConfirmationCodeFromURL(_ confirmationCode: String) {

        self.tap_loadViewIfNotLoaded()

        self.confirmationCodeTextField?.text = confirmationCode
        self.validateConfirmationCode(self.confirmationCodeTextField?.text)

        if self.isNextButtonEnabled {

            self.verifyConfirmationCode()
        }
    }

    public override func viewDidLoad() {

        super.viewDidLoad()

        self.appearanceDelegate = TapLogin.appearanceDelegate
        self.setupResendTimer()
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.validateConfirmationCode(self.confirmationCodeTextField?.text)
        TapLogin.applicationInterface?.setStatusBarStyle(.lightContent, animated: animated)
    }

    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        DispatchQueue.main.async { [weak self] in

            guard self?.view.window?.isKeyWindow ?? false else { return }
            self?.confirmationCodeTextField?.becomeFirstResponder()
        }
    }

    public override func viewWillLayoutSubviews() {

        self.view.tap_stickToSuperview()
        super.viewWillLayoutSubviews()
    }

    public override func updateLocalization() {

        super.updateLocalization()

        self.title = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenTitle)

        if let nonnullConfirmationCodeTextField = self.confirmationCodeTextField {

            UITextFieldBrander.brand(nonnullConfirmationCodeTextField, with: .login)
            nonnullConfirmationCodeTextField.placeholder = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenConfirmationCodeFieldPlaceholder)
        }

        self.setupDescriptionLabel()

        self.countdownDateFormatter.locale = Locale(identifier: LocalizationManager.shared.currentLanguage)

        if let nonnullResendButton = self.resendButton {

            UIButtonBrander.brand(nonnullResendButton, with: .login)
        }

        self.updateResendButtonTitle()
    }

    deinit {

        self.invalidateResendTimer()
    }

    // MARK: - Internal -
    // MARK: Properties

    internal var country: Country?
    internal var phoneNumber: String?

    // MARK: Methods

    internal static func instantiate() -> Self {

        guard let result = UIStoryboard.login.instantiateViewController(withIdentifier: self.tap_className) as? LoginConfirmationViewController else {

            fatalError("Failed to load \(self.tap_className) from storyboard.")
        }

        result.appearanceDelegate = TapLogin.appearanceDelegate

        return result.tap_asSelf()
    }

    internal override func handleNextButtonClick() {

        self.verifyConfirmationCode()
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let maximalNumberOfSMSPerNumber: UInt = 4
        fileprivate static let toastDuration: TimeInterval = 2.0
        fileprivate static let referenceRange = 1000...9999

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var confirmationCodeTextField: UITextField?
    @IBOutlet private weak var resendButton: UIButton? {

        didSet {

            self.resendButton?.tap_stretchBackgroundImage()
        }
    }

    @IBOutlet private weak var descriptionLabel: UILabel?

    @IBOutlet private weak var clearButton: UIButton?

    private var resendButtonForceDisabled: Bool = false

    private var resendTimer: Timer?
    private var countdownDateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LocalizationManager.shared.currentLanguage)
        formatter.dateFormat = "mm:ss"

        return formatter
    }()

    private var resendButtonMode: ResendButtonMode {

        guard let loginData = LoginData.lastUsed else { return .resendCode }

        let currentTimestamp = NSDate().timeIntervalSince1970
        let timePassedSinceSMSWasSent = currentTimestamp - loginData.timestamp

        if Int(TapLogin.Constants.resendCodeTimeInSeconds - timePassedSinceSMSWasSent) > 0 {

            return .countdown
        } else if loginData.numberOfSentSMS >= Constants.maximalNumberOfSMSPerNumber {

            return .sendCompliance
        } else {

            return .resendCode
        }
    }

    // MARK: Methods

    private func invalidateResendTimer() {

        self.resendTimer?.invalidate()
        self.resendTimer = nil
    }

    private func setupResendTimer() {

        self.invalidateResendTimer()

        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateResendButton(_:)), userInfo: nil, repeats: true)
        self.resendTimer = timer

        RunLoop.main.add(timer, forMode: .commonModes)
    }

    @objc private func updateResendButton(_ timer: Timer?) {

        DispatchQueue.main.async {

            if self.resendButtonMode != .countdown {

                self.invalidateResendTimer()
            }

            self.updateResendButtonTitle()
        }
    }

    private func updateResendButtonTitle() {

        switch self.resendButtonMode {

        case .countdown:

            let loginData = LoginData.lastUsed!

            let currentTimestamp = NSDate().timeIntervalSince1970
            let timePassedSinceSMSWasSent = currentTimestamp - loginData.timestamp

            self.resendButton?.tap_title = self.countdownTitle(with: TapLogin.Constants.resendCodeTimeInSeconds - timePassedSinceSMSWasSent)

        case .sendCompliance:

            self.resendButton?.tap_title = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenDidNotReceiveCodeButtonTitle)

        case .resendCode:

            self.resendButton?.tap_title = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenResendCodeButtonTitle)
        }
    }

    private func countdownTitle(with remainingTime: TimeInterval) -> String {

        return self.countdownDateFormatter.string(from: Date(timeIntervalSince1970: remainingTime))
    }

    private func validateConfirmationCode(_ confirmationCode: String?) {

        self.isNextButtonEnabled = TapConfirmationCodeHandler.confirmationCodeValidationState(confirmationCode) == .valid
    }

    private func setupDescriptionLabel() {

        guard let nonnullDescriptionLabel = self.descriptionLabel else { return }
        guard let phoneNumber = LoginData.lastUsed?.phoneNumber else { return }
        guard let textFormat = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenDescriptionLabelTextFormat) else { return }

        nonnullDescriptionLabel.text = "\(textFormat)\n\(phoneNumber.countryISDNumber) \(phoneNumber.number)"

        UILabelBrander.brand(nonnullDescriptionLabel, with: .login)
    }

    private func verifyConfirmationCode() {

        guard let apiHandler = TapLogin.apiHandler else { return }

        self.view.endEditing(true)
        BlockUIViewController.blockUI {

            let confirmationCode = self.confirmationCodeTextField?.text ?? String.tap_empty
            let phoneNumber = TapLogin.dataSource?.storedPhoneNumber ?? String.tap_empty

            apiHandler.callConfirmationAPI(with: phoneNumber, confirmationCode: confirmationCode) { [weak self] success in

                if success {

                    if let country = TapLogin.dataSource?.storedCountry {

                        apiHandler.usePhoneNumber(phoneNumber, country: country)
                    }

                } else {

                    self?.confirmationCodeTextField?.resignFirstResponder()
                }

                BlockUIViewController.unblockUI { }
            }
        }
    }

    private func resendConfirmationCode() {

        guard let apiHandler = TapLogin.apiHandler else { return }

        self.resendButtonForceDisabled = true

        BlockUIViewController.blockUI {

            apiHandler.resendConfirmationCode { [weak self] (success) in

                guard let strongSelf = self else {

                    BlockUIViewController.unblockUI {}
                    return
                }

                BlockUIViewController.unblockUI {

                    strongSelf.resendButtonForceDisabled = false

                    LoginData.lastUsed?.numberOfSentSMS += 1
                    LoginData.lastUsed?.timestamp = NSDate().timeIntervalSince1970

                    strongSelf.setupResendTimer()
                    strongSelf.updateResendButtonTitle()

                    if success {

                        if let toastText = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenResendActionToastText) {

                            var toastStyle = ToastManager.shared.style
                            ToastStyleBrander.brand(&toastStyle, with: .login)
                            strongSelf.view.makeToast(toastText, duration: Constants.toastDuration, position: .center, style: toastStyle)
                        }
                    }
                }
            }
        }
    }

    private func composeCompliantEmail() {

        let referenceID = self.generateReference()
        self.sendComplaint(with: referenceID)

        guard TapMessaging.shared.canSendMail else {

            TapLogin.delegate?.loginConfirmationControllerDeviceCannotSendMail(self)
            return
        }

        guard let subject = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenComplainceEmailSubject) else { return }
        guard let recipient = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenComplainceEmailRecipient) else { return }
        let emailBody = MailBody(content: self.complainceEmailBody(with: referenceID), isHTML: false)

        TapMessaging.shared.showMailComposeController(with: subject, recipients: [recipient], body: emailBody, attachments: nil) { [weak self] (result) in

            guard let strongSelf = self else { return }

            switch result {

            case .failed:

                TapLogin.delegate?.loginConfirmationControllerDidFailToSendComplainceEmail(strongSelf)

            default:

                break
            }
        }
    }

    private func generateReference() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.tap_enUS
        dateFormatter.dateFormat = "YYYYMMdd"

        let date = dateFormatter.string(from: Date())
        let randomNumber = Constants.referenceRange.tap_randomValue

        return "1000\(date)\(randomNumber)"
    }

    private func complainceEmailBody(with referenceID: String) -> String {

        var emailBody: String

        if let countryCode = self.country?.isdNumber,
            let number = self.phoneNumber,
            let bodyFormat = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenComplainceEmailBodyPhoneNumberTextFormat) {

            let phoneString = "+\(countryCode) \(number)"
            emailBody = "\(bodyFormat)\n\(phoneString)\n"
        } else {

            emailBody = String.tap_empty
        }

        if let referenceFormat = TapLogin.localizationDataSource?.localizedString(for: .loginConfirmationScreenComplainceEmailBodyReferenceIDTextFormat) {

            emailBody.append("\(referenceFormat)\n\n\(referenceID)")
        }

        return emailBody
    }

    private func sendComplaint(with referenceID: String) {

        TapLogin.apiHandler?.callComplaintAPI(with: referenceID) {_ in }
    }

    @IBAction private func resendButtonTouchUpInside(_ sender: UIButton) {

        guard !self.resendButtonForceDisabled else { return }

        switch self.resendButtonMode {

        case .countdown:

            break

        case .resendCode:

            self.resendConfirmationCode()
            TapLogin.delegate?.loginConfirmationControllerResendCodeButtonClicked(self)

        case .sendCompliance:

            self.composeCompliantEmail()
        }

        self.updateResendButtonTitle()
    }

    @IBAction private func confirmationTextFieldEditingChanged(_ sender: UITextField) {

        self.clearButton?.isHidden = (sender.text?.tap_length ?? 0) == 0

        self.validateConfirmationCode(sender.text)
    }

    @IBAction private func clearButtonTouchUpInside(_ sender: UIButton) {

        self.confirmationCodeTextField?.text = nil
        self.clearButton?.isHidden = true

        self.validateConfirmationCode(self.confirmationCodeTextField?.text)
    }
}

extension LoginConfirmationViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let numberOnlyText = textField.text?.tap_replacing(range: range, withString: string).trimmingCharacters(in: CharacterSet.whitespaces) ?? String.tap_empty

        let state = TapConfirmationCodeHandler.confirmationCodeValidationState(numberOnlyText)

        return state != .invalid
    }
}
