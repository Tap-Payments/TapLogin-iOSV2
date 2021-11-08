//
//  CountryTableViewCell.swift
//  TapCountriesKit-UI
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapViewControllerV2
import UIKit

/// Table View Cell to display country.
internal class CountryTableViewCell: TapTableViewCell {

    // MARK: - Internal -
    // MARK: Methods

    /// Fills cell content with ISO code or ISD number (based on what is required, country name and flag image).
    ///
    /// - Parameters:
    ///   - isoCodeOrISDNumber: ISO code or ISD number
    ///   - countryName: Country name
    ///   - flagImage: Flag image.
    internal func fill(with isoCodeOrISDNumber: String, countryName: String, flagImage: UIImage?) {

        self.codeLabel?.text = isoCodeOrISDNumber
        self.nameLabel?.text = countryName
        self.flagImageView?.image = flagImage

        self.applyFonts()
    }

    internal override func setSelected(_ selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)
        self.checkmarkImageView?.isHidden = !selected
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var codeLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var flagImageView: UIImageView?
    @IBOutlet private weak var checkmarkImageView: UIImageView?

    // MARK: Methods

    private func applyFonts() {

        self.codeLabel?.font = TapFont.helveticaNeueLight.localizedWithSize(15.0, languageIdentifier: Locale.current.identifier)
        
        self.nameLabel?.font = TapFont.helveticaNeueLight.localizedWithSize(15.0, languageIdentifier: Locale.current.identifier)
    }
}
