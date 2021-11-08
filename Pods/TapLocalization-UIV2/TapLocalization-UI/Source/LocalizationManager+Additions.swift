//
//  LocalizationManager+Additions.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/11/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFlagsKitV2
import TapLocalizationV2
import UIKit

public extension LocalizationManager {

    // MARK: - Public -
    // MARK: Methods

    /// Returns language icon.
    ///
    /// - Parameter language: Language
    /// - Returns: Icon.
    public func icon(for language: String) -> UIImage? {

        #if TARGET_INTERFACE_BUILDER

            return TapFlagsKit.flag(for: Locale.LocaleIdentifier.en)

        #else

        guard let flagName = self.flagImageName(for: language) else { return TapFlagsKit.flag(for: Locale.TapLocaleIdentifier.enUS) }

            return TapFlagsKit.flag(named: flagName)

        #endif
    }
}
