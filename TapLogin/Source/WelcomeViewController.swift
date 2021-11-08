//
//  WelcomeViewController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 1/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2.Swift

import class TapBrandBookIOSV2.UIButtonBrander
import class TapBrandBookIOSV2.UILabelBrander
import class TapLocalization_UIV2.LanguageSelectionViewController
import class TapLocalization_UIV2.LanguageView
import protocol TapLocalization_UIV2.LanguageViewDelegate
import enum TapLocalization_UIV2.LocalizationLocalization
import protocol TapLocalization_UIV2.LocalizationLocalizationDataSource
import func TapSwiftFixesV2.performOnMainThread
import class TapViewControllerV2.TapViewController
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UIButton.UIButton
import struct UIKit.UIGeometry.UIEdgeInsets

/// Welcome View Controller.
public class WelcomeViewController: TapViewController {

    // MARK: - Internal -
    // MARK: Methods

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.appearanceDelegate = TapLogin.appearanceDelegate
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        TapLogin.applicationInterface?.setStatusBarStyle(.lightContent, animated: animated)
    }

    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        self.view.tap_setExclusiveTouchOnAllSubviews(true)
    }

    public override func viewWillLayoutSubviews() {

        if let nonnullWindow = self.view.window {

            self.languageViewTopOffsetConstraint?.constant = Constants.languageViewTopOffset - nonnullWindow.convert(.zero, from: self.view).y
        }

        super.viewWillLayoutSubviews()
    }

    public override func updateLocalization() {

        super.updateLocalization()

        if let nonnullVersionLabel = self.versionLabel {

            UILabelBrander.brand(nonnullVersionLabel, with: .versionText)
            nonnullVersionLabel.text = TapLogin.localizationDataSource?.localizedString(for: .welcomeScreenVersionLabelText)
        }

        self.setupStartButton()
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let startButtonTitleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 3.0, right: 23.0)
        fileprivate static let startButtonImageEdgeInsets = UIEdgeInsets(top: 0.0, left: 140.0, bottom: 0.0, right: 0.0)

        fileprivate static let languageViewTopOffset: CGFloat = 32.0

        fileprivate static let startButtonImage: UIImage = {

            guard let result = UIImage(named: "arrow_welcome", in: .loginResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to find resource named arrow_welcome in login resources bundle.")
            }

            return result
        }()

        fileprivate static let startButtonHighlightedImage: UIImage = {

            guard let result = UIImage(named: "arrow_welcome_pressed", in: .loginResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to find resource named arrow_welcome_pressed in login resources bundle.")
            }

            return result
        }()

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var versionLabel: UILabel? {

        didSet {

            self.setupVersionLabelVisibility()
        }
    }

    @IBOutlet private weak var startButton: UIButton? {

        didSet {

            self.setupStartButton()
        }
    }

    @IBOutlet private weak var languageViewTopOffsetConstraint: NSLayoutConstraint?

    // MARK: Methods

    @IBAction private func startButtonTouchUpInside(_ sender: Any) {

        self.showPhoneNumberController()
    }

    private func setupVersionLabelVisibility() {

        #if RELEASE

            self.versionLabel?.isHidden = true

        #else

            self.versionLabel?.isHidden = false

        #endif
    }

    private func setupStartButton() {

        guard let nonnullStartButton = self.startButton else { return }

        UIButtonBrander.brand(nonnullStartButton, with: .welcomeStart)

        nonnullStartButton.tap_title = TapLogin.localizationDataSource?.localizedString(for: .welcomeScreenStartButtonTitle)

        if TapLogin.applicationInterface?.layoutDirection == .rightToLeft {

            nonnullStartButton.setImage(Constants.startButtonImage.tap_mirrored, for: .normal)
            nonnullStartButton.setImage(Constants.startButtonHighlightedImage.tap_mirrored, for: .highlighted)

            nonnullStartButton.titleEdgeInsets = Constants.startButtonTitleEdgeInsets.tap_mirrored
            nonnullStartButton.imageEdgeInsets = Constants.startButtonImageEdgeInsets.tap_mirrored
        } else {

            nonnullStartButton.setImage(Constants.startButtonImage, for: .normal)
            nonnullStartButton.setImage(Constants.startButtonHighlightedImage, for: .highlighted)

            nonnullStartButton.titleEdgeInsets = Constants.startButtonTitleEdgeInsets
            nonnullStartButton.imageEdgeInsets = Constants.startButtonImageEdgeInsets
        }
    }

    private func showPhoneNumberController(withOpenedKeyboard: Bool = true) {

        TapLoginRouter.showLoginContainerController { loginContainerViewController in

            loginContainerViewController.phoneNumberControllerKeyboardIsOpenedByDefault = withOpenedKeyboard
        }
    }
}

// MARK: - LanguageViewDelegate
extension WelcomeViewController: LanguageViewDelegate {

    public func languageViewClicked(_ languageView: LanguageView) {

        performOnMainThread { [weak self] in

            let languageSelectionController = LanguageSelectionViewController.instantiate()
            languageSelectionController.appearanceDelegate = TapLogin.appearanceDelegate
            languageSelectionController.applicationInterface = TapLogin.applicationInterface
            languageSelectionController.localizationDataSource = self
            languageSelectionController.delegate = TapLogin.languageSelectionViewControllerDelegate

            guard let languageNavigationController = languageSelectionController.navigationController else { return }

            DispatchQueue.main.async {

                self?.present(languageNavigationController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - LocalizationLocalizationDataSource
extension WelcomeViewController: LocalizationLocalizationDataSource {

    public func localizedString(for key: LocalizationLocalization) -> String {

        guard let dataSource = TapLogin.localizationDataSource else { return .tap_empty }

        switch key {

        case .navigationBarCancelTitle:

            return dataSource.localizedString(for: .languageSelectionScreenNavigationBarCancelButtonTitle)

        case .navigationBarDoneTitle:

            return dataSource.localizedString(for: .languageSelectionScreenNavigationBarDoneButtonTitle)

        case .navigationBarTitle:

            return dataSource.localizedString(for: .languageSelectionScreenNavigationBarTitle)
        }
    }
}
