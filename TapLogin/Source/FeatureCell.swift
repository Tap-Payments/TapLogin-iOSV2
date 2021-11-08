//
//  FeatureCell.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapBrandBookIOSV2
import TapViewControllerV2
import UIKit

internal class FeatureCell: TapCollectionViewCell {

    // MARK: - Internal -
    // MARK: Methods

    internal func setTitle(_ title: String, detailedTitle: String, image: UIImage) {

        self.titleLabel?.text = title
        self.detailedTitleLabel?.text = detailedTitle
        self.iconImageView?.image = image

        self.updateLocalization()
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var detailedTitleLabel: UILabel?
    @IBOutlet private weak var iconImageView: UIImageView?

    @IBOutlet private weak var titleLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var detailedTitleLabelHeightConstraint: NSLayoutConstraint?

    // MARK: Methods

    private func updateLocalization() {

        if let nonnullTitleLabel = self.titleLabel {

            UILabelBrander.brand(nonnullTitleLabel, with: .welcomeFeatureTitle)
        }

        if let nonnullDetailedTitleLabel = self.detailedTitleLabel {

            UILabelBrander.brand(nonnullDetailedTitleLabel, with: .welcomeFeatureSubtitle)
        }

        self.layoutLabels()
    }

    private func layoutLabels() {

        guard let nonnullTitleLabel = self.titleLabel, let titleFont = nonnullTitleLabel.font else { return }
        guard let nonnullDetailedLabel = self.detailedTitleLabel, let detailedFont = nonnullDetailedLabel.font else { return }
        let titleText = nonnullTitleLabel.text ?? .tap_empty
        let detailedText = nonnullDetailedLabel.text ?? .tap_empty

        let titleHeight = ceil(titleText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                                      options: .usesLineFragmentOrigin,
                                                      attributes: [.font: titleFont],
                                                      context: nil).size.height)

        var descriptionHeight = ceil(detailedText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                                               options: .usesLineFragmentOrigin,
                                                               attributes: [.font: detailedFont],
                                                               context: nil).size.height)

        if titleHeight + descriptionHeight > self.bounds.height {
            descriptionHeight = self.bounds.height - titleHeight
        }

        self.titleLabelHeightConstraint?.constant = titleHeight
        self.detailedTitleLabelHeightConstraint?.constant = descriptionHeight

        self.tap_layout()
    }
}
