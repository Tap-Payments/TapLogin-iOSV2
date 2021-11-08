//
//  UIView+Additions.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/11/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import QuartzCore
import TapLocalizationV2
import UIKit

/// Useful UIView extension.
public extension UIView {

    // MARK: - Public -
    // MARK: Methods

    /// Mirrors the receiver if RTL layout, or makes it without any transform if LTR.
    public func mirrorIfNeeded() {

        let requiredTransform: CATransform3D
        if LocalizationManager.shared.isCurrentLanguageRightToLeft {

            requiredTransform = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
        }
        else {

            requiredTransform = CATransform3DIdentity
        }

        if !CATransform3DEqualToTransform(self.layer.transform, requiredTransform) {

            self.layer.transform = requiredTransform
        }
    }
}
/// Tap Localization UIView extension
public class TapLocalizationUIViewExtension {

    /// Mirrors UI if required based on current language layout direction.
    public static func mirrorUIViewIfNeeded(_ view: UIView) {

        view.mirrorIfNeeded()
    }

    @available(*, unavailable) private init() {}
}
