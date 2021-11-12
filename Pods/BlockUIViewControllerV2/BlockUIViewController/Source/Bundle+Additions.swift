//
//  Bundle+Additions.swift
//  BlockUIViewController
//
//  Created by Dennis Pashkov on 12/10/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

internal extension Bundle {

    // MARK: - Internal -
    // MARK: Properties

    /// Block UI View Controller Resources bundle.
    internal static let blockUIControllerResourcesBundle: Bundle = {

        guard let result = Bundle(for: BlockUIViewController.self).tap_childBundle(named: BlockUIViewControllerConstants.resourcesBundleName) else {

            fatalError("There is no \(BlockUIViewControllerConstants.resourcesBundleName) bundle.")
        }

        return result
    }()
}

private struct BlockUIViewControllerConstants {

    fileprivate static let resourcesBundleName = "BlockUIViewControllerResources"
}
