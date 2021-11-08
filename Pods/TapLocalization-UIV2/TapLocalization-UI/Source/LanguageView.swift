//
//  LanguageView.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 1/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLocalizationV2
import TapNibViewV2
import TapSwiftFixesV2
import UIKit
/// Language View.
public class LanguageView: TapNibView {

    // MARK: - Public -
    // MARK: Properties

    /// Delegate
    @IBOutlet public weak var delegate: LanguageViewDelegate?

    // MARK: Methods

    public override func willMove(toSuperview newSuperview: UIView?) {

        super.willMove(toSuperview: newSuperview)

        if newSuperview == nil {

            self.removeLocalizationObserver()
        }
        else {

            self.updateContent()
            self.addLocalizationObserver()
        }
    }

    public override class var bundle: Bundle {

        return .localizationResourcesBundle
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let arrowImage: UIImage = {

            guard let result = UIImage(named: "arrow_language", in: .localizationResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to load image named arrow_language from localization UI resources bundle.")
            }

            return result
        }()

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var arrowImageView: UIImageView? {

        didSet {

            self.arrowImageView?.image = Constants.arrowImage
        }
    }

    @IBOutlet private weak var languageImageView: UIImageView?
    @IBOutlet private weak var languageLabel: UILabel?

    // MARK: Methods

    @IBAction private func buttonClicked(_ sender: Any) {

        self.delegate?.languageViewClicked(self)
    }

    private func addLocalizationObserver() {

        NotificationCenter.default.addObserver(self, selector: #selector(localizationChanged(_:)), name: .localizationChanged, object: nil)
    }

    private func removeLocalizationObserver() {

        NotificationCenter.default.removeObserver(self, name: .localizationChanged, object: nil)
    }

    private func updateContent() {

        performOnMainThread { [weak self] in

            let currentLanguage = LocalizationManager.shared.currentLanguage

            self?.languageImageView?.image = LocalizationManager.shared.icon(for: currentLanguage)
            self?.languageLabel?.text = LocalizationManager.shared.languageInNative(for: currentLanguage)
            self?.languageLabel?.font = TapFont.helveticaNeueLight.localizedWithSize(16.0, languageIdentifier: Locale.current.identifier)
        }
    }

    @objc private func localizationChanged(_ notification: Notification) {

        self.updateContent()
    }
}
