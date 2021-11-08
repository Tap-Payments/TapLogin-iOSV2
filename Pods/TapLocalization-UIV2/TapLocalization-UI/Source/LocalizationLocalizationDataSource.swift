//
//  LocalizationLocalizationDataSource.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Localization support protocol.
public protocol LocalizationLocalizationDataSource: ClassProtocol {

    // MARK: Methods

    /// Returns localized string for a given key.
    ///
    /// - Parameter key: Key.
    /// - Returns: Localized string.
    func localizedString(for key: LocalizationLocalization) -> String
}
