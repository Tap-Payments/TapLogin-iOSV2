//
//  Bundle+Additions.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

internal extension Bundle {

    // MARK: - Internal -
    // MARK: Properties

    internal static let loginResourcesBundle: Bundle = {

        guard let result = Bundle(for: TapLogin.self).tap_childBundle(named: TapLoginConstants.resourcesBundleName) else {

            fatalError("There is no \(TapLoginConstants.resourcesBundleName) bundle.")
        }

        return result
    }()
}

private struct TapLoginConstants {

    fileprivate static let resourcesBundleName = "TapLoginResources"

    @available(*, unavailable) init() {}
}
