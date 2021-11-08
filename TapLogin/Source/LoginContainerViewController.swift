//
//  LoginContainerViewController.swift
//  goTap
//
//  Created by Dennis Pashkov on 3/17/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapAdditionsKitV2
import TapBrandBookIOSV2
import TapLocalization_UIV2
import TapViewControllerV2
import UIKit

/// View controller that displays custom navigation bar and navigation controller for login details.
public class LoginContainerViewController: TapViewController {

    // MARK: - Public -
    // MARK: Properties

    /// Defines if phone number controller keyboard should be opened by default.
    public var phoneNumberControllerKeyboardIsOpenedByDefault: Bool = true

    /// Defines if next button is enabled.
    internal var isNextButtonEnabled: Bool {

        get {

            return self.nextButton?.isEnabled ?? false
        }
        set {

            self.nextButton?.isEnabled = newValue
        }
    }

    /// Title text.
    internal var titleText: String = String.tap_empty {

        didSet {

            self.updateTitleLabelHeight(for: self.titleText)
            self.updateTitleText()
        }
    }

    // MARK: Methods

    public override func viewWillLayoutSubviews() {

        if let nonnullWindow = self.view.window {

            self.titleViewBottomOffsetConstraint?.constant = Constants.titleViewHeightFromTopOfTheScreen - nonnullWindow.convert(.zero, from: self.view).y
        }

        super.viewWillLayoutSubviews()
    }

    public override func updateLocalization() {

        super.updateLocalization()

        if let nonnullBackButton = self.backButton {

            TapLocalizationUIViewExtension.mirrorUIViewIfNeeded(nonnullBackButton)
        }

        if let nonnullNextButton = self.nextButton {

            UIButtonBrander.brand(nonnullNextButton, with: .loginHeader)
            nonnullNextButton.tap_title = TapLogin.localizationDataSource?.localizedString(for: .loginContainerScreenNextButtonTitle)
        }

        if let nonnullTitleLabel = self.titleLabel {

            UILabelBrander.brand(nonnullTitleLabel, with: .loginHeader)
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)

        if segue.identifier == Constants.contentNavigationControllerSegueIdentifier {

            self.contentNavigationController = segue.destination as? UINavigationController
        }
    }

    /// Resets all data.
    public func resetAllData() {

        _ = self.contentNavigationController?.popToRootViewController(animated: false)
        (self.contentNavigationController?.tap_rootViewController as? LoginPhoneNumberViewController)?.clearFields()
    }

    // MARK: - Internal -
    // MARK: Properties

    /// Content navigation controller.
    internal private(set) weak var contentNavigationController: UINavigationController? {

        didSet {

            self.contentNavigationController?.delegate = self

            guard let phoneNumberController = self.contentNavigationController?.tap_rootViewController as? LoginPhoneNumberViewController else { return }
            phoneNumberController.automaticallyOpensKeyboard = self.phoneNumberControllerKeyboardIsOpenedByDefault
            phoneNumberController.parentContainerController = self
        }
    }

    // MARK: Methods

    internal static func instantiate() -> Self {

        guard let result = UIStoryboard.login.instantiateViewController(withIdentifier: self.tap_className) as? LoginContainerViewController else {

            fatalError("Failed to load \(self.tap_className) from storyboard.")
        }

        return result.tap_asSelf()
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let contentNavigationControllerSegueIdentifier = "ContentNavigationControllerSegue"
        fileprivate static let titleLabelExtraHeight: CGFloat = 5.0
        fileprivate static let titleLabelFadeAnimationDuration: TimeInterval = 0.5

        fileprivate static let titleViewHeightFromTopOfTheScreen: CGFloat = 183.0

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var titleView: UIView?

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var titleLabelHeightConstraint: NSLayoutConstraint?

    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var nextButton: UIButton?

    @IBOutlet private weak var titleViewBottomOffsetConstraint: NSLayoutConstraint?

    // MARK: Methods

    @IBAction private func backButtonTouchUpInside(_ sender: Any) {

        guard let nonnullContentNavigationController = self.contentNavigationController else {

            self.dismiss()
            return
        }

        if nonnullContentNavigationController.viewControllers.count > 1 {

            DispatchQueue.main.async {

                nonnullContentNavigationController.popViewController(animated: true)
            }
        } else {

            self.dismiss()
        }
    }

    @IBAction private func nextButtonTouchUpInside(_ sender: Any) {

        (self.contentNavigationController?.viewControllers.last as? LoginContentViewController)?.handleNextButtonClick()
    }

    @IBAction private func viewTouched(_ recognizer: UIGestureRecognizer) {

        if [UIGestureRecognizerState.cancelled, UIGestureRecognizerState.ended, UIGestureRecognizerState.failed].contains(recognizer.state) {

            self.view.tap_firstResponder?.resignFirstResponder()
        }
    }

    private func dismiss() {

        DispatchQueue.main.async {

            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    private func updateTitleLabelHeight(for textString: String?) {

        guard let labelWidth = self.titleLabel?.bounds.width else { return }
        guard let text = self.titleLabel?.text, let font = self.titleLabel?.font else { return }

        let boundingSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let titleAttributes: [NSAttributedStringKey: Any] = [.font: font, .paragraphStyle: paragraphStyle]

        let height = text.boundingRect(with: boundingSize, options: drawingOptions, attributes: titleAttributes, context: nil).size.height + Constants.titleLabelExtraHeight

        if self.titleLabelHeightConstraint?.constant != height {

            self.titleLabelHeightConstraint?.constant = height

            self.titleView?.tap_layout()
        }
    }

    private func updateTitleText() {

        guard self.titleLabel?.text != self.titleText else { return }

        let halfAnimationDuration = 0.5 * Constants.titleLabelFadeAnimationDuration

        let fadeInAnimation: TypeAlias.ArgumentlessClosure = { [weak self] in

            self?.titleLabel?.alpha = 0.0
        }

        let fadeOutAnimation: TypeAlias.ArgumentlessClosure = { [weak self] in

            self?.titleLabel?.alpha = 1.0
        }

        UIView.animate(withDuration: halfAnimationDuration, delay: 0.0, options: [.curveEaseIn], animations: fadeInAnimation) { [weak self] _ in

            self?.titleLabel?.text = self?.titleText
            UIView.animate(withDuration: halfAnimationDuration, delay: 0.0, options: [.curveEaseOut], animations: fadeOutAnimation, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension LoginContainerViewController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return NavigationControllerOldSchoolTransitionAnimation(operation: operation)
    }
}
