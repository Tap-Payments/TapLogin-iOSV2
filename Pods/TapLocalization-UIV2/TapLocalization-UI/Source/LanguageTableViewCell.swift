//
//  LanguageTableViewCell.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 2/1/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

import TapFontsKitV2
import TapLocalizationV2
import TapViewControllerV2
import UIKit

/// Language cell.
internal class LanguageTableViewCell: TapTableViewCell {

    // MARK: - Internal -
    // MARK: Methods

    /// Sets up icon.
    ///
    /// - Parameter icon: Icon to set up.
    internal func setIcon(_ icon: UIImage?) {

        self.iconImageView?.image = icon
    }

    internal var titleTextAlignment: NSTextAlignment = .left {

        didSet {

            self.titleLabel?.textAlignment = self.titleTextAlignment
        }
    }

    /// Sets up cell content with language identifier.
    ///
    /// - Parameter languageIdentifier: Language identifier to set up cell with.
    internal func setLanguageIdentifier(_ languageIdentifier: String) {

        self.titleLabel?.font = TapFont.arabicHelveticaNeueLight.localizedWithSize(15.0, languageIdentifier: languageIdentifier)
        self.titleLabel?.text = LocalizationManager.shared.languageInNative(for: languageIdentifier)
    }

    internal override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

        self.checkmarkImageView?.isHidden = !selected
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let checkmarkImage: UIImage = {

            guard let result = UIImage(named: "ic_item_check_mark_blue", in: .localizationResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to load image named ic_item_check_mark_blue from localization UI resources bundle.")
            }

            return result
        }()

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var iconImageView: UIImageView?

    @IBOutlet private weak var titleLabel: UILabel? {

        didSet {

            self.titleLabel?.textAlignment = self.titleTextAlignment
        }
    }

    @IBOutlet private weak var checkmarkImageView: UIImageView? {

        didSet {

            self.checkmarkImageView?.image = Constants.checkmarkImage
        }
    }

    @IBOutlet private weak var bottomSeparatorHeightConstraint: NSLayoutConstraint? {

        didSet {

            self.bottomSeparatorHeightConstraint?.constant = UIScreen.main.tap_numberOfPointsInOnePixel
        }
    }
}
