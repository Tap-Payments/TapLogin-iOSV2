//
//  TapFlagsKit.swift
//  TapFlagsKit
//
//  Created by Dennis Pashkov on 11/16/17.
//  Copyright © 2017-2018 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

import UIKit

/// Tap Flags Kit.
public class TapFlagsKit {

    // MARK: - Public -
    // MARK: Methods

    /// Returns flag with a given name.
    ///
    /// - Parameter named: Flag name.
    /// - Returns: Flag image.
    public static func flag(named imageName: String) -> UIImage? {

        return UIImage(named: imageName.uppercased(), in: self.resourcesBundle, compatibleWith: nil)
    }

    /// Returns flag for the country with a given country code.
    ///
    /// - Parameter countryCode: Country code.
    /// - Returns: Flag image.
    public static func flag(for countryCode: String) -> UIImage? {

        return UIImage(named: countryCode.uppercased(), in: self.resourcesBundle, compatibleWith: nil)
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let resourcesBundleName = "Flags"

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    private static let resourcesBundle: Bundle = {

        guard let bundle = Bundle(for: TapFlagsKit.self).tap_childBundle(named: Constants.resourcesBundleName) else {

            fatalError("There is no bundle \(Constants.resourcesBundleName)")
        }

        return bundle
    }()

    // MARK: Methods

    @available(*, unavailable) private init() {}
}
