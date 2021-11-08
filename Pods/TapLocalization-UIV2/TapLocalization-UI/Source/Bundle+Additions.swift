//
//  Bundle+Additions.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Handy extension to Bundle class.
internal extension Bundle {

    // MARK: - Internal -
    // MARK: Properties

    /// Countries kit resources bundle.
    internal static let localizationResourcesBundle: Bundle = {

        guard let result = Bundle(for: LanguageSelectionViewController.self).tap_childBundle(named: LocalizationConstants.resourcesBundleName) else {

            fatalError("There is no \(LocalizationConstants.resourcesBundleName) bundle.")
        }

        return result
    }()
}

private struct LocalizationConstants {

    fileprivate static let resourcesBundleName = "TapLocalizationUIResources"
}
