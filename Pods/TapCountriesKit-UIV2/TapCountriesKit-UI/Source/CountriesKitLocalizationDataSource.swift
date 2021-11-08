//
//  CountriesKitLocalizationDataSource.swift
//  TapCountriesKit-UI
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Localization support protocol.
public protocol CountriesKitLocalizationDataSource: class {

    // MARK: Methods

    /// Returns localized string for a given key.
    ///
    /// - Parameter key: Key.
    /// - Returns: Localized string.
    func localizedString(for key: CountriesKitLocalization) -> String
}
