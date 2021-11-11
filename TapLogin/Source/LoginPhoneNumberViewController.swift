//
//  LoginPhoneNumberViewController.swift
//  goTap
//
//  Created by Dennis Pashkov on 11/18/16.
//  Copyright © 2016 Tap Payments. All rights reserved.
//

import EditableTextInsetsTextFieldV2
import TapBrandBookIOSV2
import TapCountriesKitV2
import TapCountriesKit_UIV2
import TapLocalizationV2
import TapSwiftFixesV2
import TapViewControllerV2
import UIKit
/// View controller to login with phone number.
public class LoginPhoneNumberViewController: LoginContentViewController {

    // MARK: - Public -
    // MARK: Methods

    public override func viewDidLoad() {

        super.viewDidLoad()

        self.appearanceDelegate = TapLogin.appearanceDelegate
        self.updateCountryCode(with: nil)
        self.phoneNumberTextField?.clearButtonPosition = .right
        self.phoneNumberTextField?.text = TapLogin.dataSource?.storedPhoneNumber

        self.setupLastUsedLoginData()

        NotificationCenter.default.addObserver(self, selector: #selector(updateCountryCode(with:)), name: .countriesDidFinishLoading, object: nil)
        self.validatePhoneNumber()
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        self.validatePhoneNumber()
        TapLogin.applicationInterface?.setStatusBarStyle(.lightContent, animated: animated)
    }

    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        if self.automaticallyOpensKeyboard && AlertViewController.tap_findInHierarchy() == nil {

            DispatchQueue.main.async { [weak self] in

                self?.phoneNumberTextField?.becomeFirstResponder()
            }
        }

        if #available(iOS 9.0, *) {

            if let attribute = TapLogin.applicationInterface?.requiredSemanticContentAttribute {

                self.navigationController?.navigationBar.tap_applySemanticContentAttribute(attribute)
            }
        }
    }

    public override func viewWillLayoutSubviews() {

        self.view.tap_stickToSuperview()
        super.viewWillLayoutSubviews()
    }

    public override func updateLocalization() {

        super.updateLocalization()
        self.title = TapLogin.localizationDataSource?.localizedString(for: .loginPhoneNumberScreenTitle)

        if let nonnullPhoneNumberField = self.phoneNumberTextField {

            UITextFieldBrander.brand(nonnullPhoneNumberField, with: .login)
            nonnullPhoneNumberField.placeholder = TapLogin.localizationDataSource?.localizedString(for: .loginPhoneNumberScreenNumberFieldPlaceholder)
        }

        if let nonnullDescriptionLabel = self.descriptionLabel {

            nonnullDescriptionLabel.text = TapLogin.localizationDataSource?.localizedString(for: .loginPhoneNumberScreenDescription)
            UILabelBrander.brand(nonnullDescriptionLabel, with: .login)
        }
    }

    // MARK: - Internal -
    // MARK: Properties

    /// Defines if keyboard is opened automatically.
    internal var automaticallyOpensKeyboard: Bool = true {

        didSet {

            if self.phoneNumberTextField?.isFirstResponder ?? false {

                DispatchQueue.main.async {

                    self.phoneNumberTextField?.resignFirstResponder()
                }
            }
        }
    }

    // MARK: Methods

    /// Clears all input fields.
    internal func clearFields() {

        self.phoneNumberTextField?.text = nil
    }

    public override func handleNextButtonClick() {

        self.view.endEditing(true)
        self.register()
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var phoneNumberTextField: EditableTextInsetsTextField?

    @IBOutlet private weak var countryCodeButton: UIButton?

    @IBOutlet private weak var countryCodeImageView: UIImageView?

    @IBOutlet private weak var descriptionLabel: UILabel?

    @IBOutlet private weak var countryCodeActivityIndicator: UIActivityIndicatorView?

    private var selectedCountry: Country? {

        didSet {

            guard let country = self.selectedCountry else { return }

            self.countryCodeButton?.tap_title = country.displayedISDNumber
            self.validatePhoneNumber()
        }
    }

    // MARK: Methods

    @IBAction private func countriesListButtonTouchUpInside(_ sender: Any) {

        let countriesListController = CountriesListViewController.instantiate()
        countriesListController.appearanceDelegate = TapLogin.appearanceDelegate
        countriesListController.countriesDisplayMode = .isdNumber
        countriesListController.countriesSortingClosure = { [weak self] (unsortedCountries) in

            if let curSelectedCountry = self?.selectedCountry, let index = unsortedCountries.index(of: curSelectedCountry) {

                var sortedCountries = unsortedCountries
                let firstCountry = sortedCountries.remove(at: index)
                sortedCountries.insert(firstCountry, at: 0)

                return sortedCountries
            }

            return unsortedCountries
        }

        countriesListController.localizationDataSource = self
        countriesListController.delegate = self
        countriesListController.applicationInterface = TapLogin.applicationInterface
        countriesListController.selectedCountry = self.selectedCountry

        guard let countriesNavigationController = countriesListController.navigationController else { return }

        DispatchQueue.main.async { [weak self] in

            self?.present(countriesNavigationController, animated: true)
        }
    }

    @IBAction private func phoneNumberTextFieldDidChange(_ sender: Any) {

        self.validatePhoneNumber()
    }

    private func setupLastUsedLoginData() {

        guard LoginData.lastUsed == nil else { return }

        guard let number = TapLogin.dataSource?.storedPhoneNumber, let isdCode = TapLogin.dataSource?.storedCountry?.displayedISDNumber else { return }
        let phoneNumber = PhoneNumber(countryISDNumber: isdCode, number: number)

        LoginData.lastUsed = LoginData(phoneNumber: phoneNumber, timestamp: Date().timeIntervalSince1970, numberOfSentSMS: 0, isCountryAvailable: false)
    }

    @objc private func updateCountryCode(with notification: Notification?) {

        let datasource = CountriesDataSource.shared

        performOnMainThread { [weak self] in

            guard let strongSelf = self else { return }

            if let country = TapLogin.dataSource?.storedCountry {

                strongSelf.selectedCountry = country
            } else if let simCardCountry = datasource.simCardCountry {

                strongSelf.selectedCountry = simCardCountry
            } else if let localeRegionCountry = datasource.deviceLocaleRegionCountry {

                strongSelf.selectedCountry = localeRegionCountry
            } else {

                strongSelf.selectedCountry = datasource.countriesAvailableForRegistration.first
            }

            strongSelf.countryCodeActivityIndicator?.isHidden = strongSelf.selectedCountry != nil
        }
    }

    private func validatePhoneNumber() {

        let phoneNumber = self.phoneNumberTextField?.text ?? String.tap_empty
        if let country = self.selectedCountry {

            let validForPattern = country.phoneNumberPattern == nil ? true : phoneNumber.tap_isValid(for: country.phoneNumberPattern)

            self.isNextButtonEnabled = phoneNumber.tap_containsOnlyInternationalDigits && validForPattern

        } else {

            self.isNextButtonEnabled = false
        }
    }

    private func register() {

        guard let apiHandler = TapLogin.apiHandler else { return }
        guard let number = self.phoneNumberTextField?.text, let country = self.selectedCountry else { return }

        let phoneNumber = PhoneNumber(countryISDNumber: country.displayedISDNumber, number: number)
        let isCountryAvailable = LoginData.lastUsed?.isCountryAvailable

        if let nonnulLoginData = LoginData.lastUsed, Date().timeIntervalSince1970 - nonnulLoginData.timestamp < TapLogin.Constants.resendCodeTimeInSeconds, isCountryAvailable == true {

            apiHandler.usePhoneNumber(number, country: country)
            TapLoginRouter.showLoginConfirmationController()
        } else {

            BlockUIViewController.blockUI {

                apiHandler.callLoginAPI(with: number, country: country) { success in

                    BlockUIViewController.unblockUI {

                        guard success else { return }

                        LoginData.lastUsed = LoginData(phoneNumber: phoneNumber,
                                                       timestamp: NSDate().timeIntervalSince1970,
                                                       numberOfSentSMS: 1,
                                                       isCountryAvailable: true)

                        TapLoginRouter.showLoginConfirmationController()
                    }
                }
            }
        }
    }
}

// MARK: - CountriesKitLocalizationDataSource
extension LoginPhoneNumberViewController: CountriesKitLocalizationDataSource {

    public func localizedString(for key: CountriesKitLocalization) -> String {

        guard let nonnullDataSource = TapLogin.localizationDataSource else { return .tap_empty }

        switch key {

        case .navigataionBarCancelTitle:

            return nonnullDataSource.localizedString(for: .countriesListScreenNavigationBarCancelTitle)

        case .searchBarCancelTitle:

            return nonnullDataSource.localizedString(for: .countriesListScreenSearchBarCancelTitle)

        case .navigationBarDoneTitle:

            return nonnullDataSource.localizedString(for: .countriesListScreenNavigationBarDoneTitle)

        case .navigationBarTitle:

            return nonnullDataSource.localizedString(for: .countriesListScreenNavigationBarTitle)

        case .searchBarPlaceholder:

            return nonnullDataSource.localizedString(for: .countriesListScreenSearchBarPlaceholder)
        }
    }
}

// MARK: - CountriesListViewControllerDelegate
extension LoginPhoneNumberViewController: CountriesListViewControllerDelegate {

    public func countriesListViewController(_ countriesListViewController: CountriesListViewController, didFinishWith country: TapCountriesKitV2.Country) {

        self.selectedCountry = country
    }
}
