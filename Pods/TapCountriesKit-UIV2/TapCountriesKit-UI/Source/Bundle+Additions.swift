//
//  Bundle+Additions.swift
//  TapCountriesKit
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Handy extension to Bundle class.
internal extension Bundle {

    // MARK: - Internal -
    // MARK: Properties

    /// Countries kit resources bundle.
    internal static let countriesKitResourcesBundle: Bundle = {

        guard let result = Bundle(for: CountriesListViewController.self).tap_childBundle(named: TapCountriesKitConstants.resourcesBundleName) else {

            fatalError("There is no \(TapCountriesKitConstants.resourcesBundleName) bundle.")
        }

        return result
    }()
}

private struct TapCountriesKitConstants {

    fileprivate static let resourcesBundleName = "TapCountriesKitUIResources"
}
