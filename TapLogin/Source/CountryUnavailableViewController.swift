//
//  CountryUnavailableViewController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/14/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class TapBrandBookIOSV2.UIButtonBrander
import class TapBrandBookIOSV2.UILabelBrander
import class TapFlagsKitV2.TapFlagsKit
import func TapSwiftFixesV2.performOnMainThread
import class TapViewControllerV2.AlertViewController
import protocol TapViewControllerV2.AlertViewControllerDelegate
import class TapViewControllerV2.TapViewController
import class UIKit.UIButton.UIButton
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIStoryboard.UIStoryboard

/// CountryUnavailableViewController class.
public class CountryUnavailableViewController: TapViewController {

    // MARK: - Public -

    public typealias PrioritizationDetailsClosure = (String?, String?, String?) -> Void

    // MARK: Methods

    /// Instantiates new instance of CountryUnavailableViewController.
    public static func instantiate() -> Self {

        guard let result = UIStoryboard.login.instantiateViewController(withIdentifier: self.tap_className) as? CountryUnavailableViewController else {

            fatalError("Failed to load \(self.tap_className) from storyboard.")
        }

        result.appearanceDelegate = TapLogin.appearanceDelegate

        return result.tap_asSelf()
    }

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.prioritizeButton?.tap_stretchBackgroundImage()
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        TapLogin.applicationInterface?.setStatusBarStyle(.lightContent, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {

        self.navigationController?.navigationBar.isHidden = true
        super.viewWillDisappear(animated)
    }

    public override func updateLocalization() {

        super.updateLocalization()

        self.backButton?.mirrorIfNeeded()

        if let nonnullDescriptionLabel = self.descriptionLabel {

            UILabelBrander.brand(nonnullDescriptionLabel, with: .welcomeFeatureSubtitle)
            nonnullDescriptionLabel.text = TapLogin.localizationDataSource?.localizedString(for: .countryUnavailableScreenDescription)
        }

        if let nonnullButtonDescriptionLabel = self.prioritizeButtonDescriptionLabel {

            UILabelBrander.brand(nonnullButtonDescriptionLabel, with: .login)
            nonnullButtonDescriptionLabel.text = TapLogin.localizationDataSource?.localizedString(for: .countryUnavailableScreenPrioritizeButtonDescription)
        }

        if let nonnullPrioritizeButton = self.prioritizeButton {

            UIButtonBrander.brand(nonnullPrioritizeButton, with: .login)
            nonnullPrioritizeButton.tap_title = TapLogin.localizationDataSource?.localizedString(for: .countryUnavailableScreenPrioritizeButtonTitle)
        }
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var backButton: UIButton?

    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var prioritizeButtonDescriptionLabel: UILabel?
    @IBOutlet private weak var prioritizeButton: UIButton?

    @IBOutlet private weak var iconImageView: UIImageView? {

        didSet {

            self.iconImageView?.image = TapLogin.dataSource?.countryUnavailableScreenLogoImage
        }
    }

    private var isPrioritizingCountry: Bool = false

    // MARK: Methods

    @IBAction private func backButtonTouchUpInside(_ sender: Any) {

        self.dismiss()
    }

    @IBAction private func prioritizeButtonTouchUpInside(_ sender: Any) {

        self.prioritizeCountry()
    }

    private func prioritizeCountry() {

        guard let apiHandler = TapLogin.apiHandler else { return }
        guard !self.isPrioritizingCountry else { return }

        self.isPrioritizingCountry = true

        BlockUIViewController.blockUI {

            apiHandler.prioritizeCountry { [weak self] (countryCode, countryName, descriptionText) in

                guard let strongSelf = self else {

                    BlockUIViewController.unblockUI {}
                    return
                }

                BlockUIViewController.unblockUI { [weak strongSelf] in

                    guard let strongerSelf = strongSelf else { return }

                    strongerSelf.isPrioritizingCountry = false

                    guard let nonnullCountryCode = countryCode, let nonnullCountryName = countryName, let nonnullDescription = descriptionText else { return }

                    let alert = AlertViewController.instantiate()

                    alert.delegate = strongerSelf
                    alert.flagImage = TapFlagsKit.flag(for: nonnullCountryCode)
                    alert.titleText = nonnullCountryName
                    alert.descriptionText = nonnullDescription

                    performOnMainThread {

                        alert.show(animated: true)
                    }
                }
            }
        }
    }

    fileprivate func dismiss() {

        DispatchQueue.main.async { [weak self] in

            _ = self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - AlertViewControllerDelegate
extension CountryUnavailableViewController: AlertViewControllerDelegate {

    public func alertViewControllerDidDismiss(_ alertController: AlertViewController) {

        self.dismiss()
    }
}
