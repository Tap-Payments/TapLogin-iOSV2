//
//  UIStoryboard+Additions.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class UIKit.UIStoryboard.UIStoryboard

/// Handy extension to UIStoryboard.
internal extension UIStoryboard {

    // MARK: - Internal -
    // MARK: Properties

    /// Countries storyboard.
    internal static let countries = UIStoryboard(name: "Language", bundle: .localizationResourcesBundle)
}
