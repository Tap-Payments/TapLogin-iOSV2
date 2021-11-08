//
//  TapLoginLocalizationDataSource.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/6/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Tap Login Localization Data Source
public protocol TapLoginLocalizationDataSource: ClassProtocol {

    // MARK: Methods

    /// Returns localized string for a given key.
    ///
    /// - Parameter key: Key.
    /// - Returns: String.
    func localizedString(for key: TapLoginLocalization) -> String
}
