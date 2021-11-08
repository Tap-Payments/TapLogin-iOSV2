//
//  InitialFeatureCellDelegate.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2
import UIKit

/// Initiial feature cell delegate.
internal protocol InitialFeatureCellDelegate: ClassProtocol {

    /// Notifies delegate that play video button was clicked.
    ///
    /// - Parameters:
    ///   - cell: Sender.
    ///   - button: Play video button.
    func initialFeatureCell(_ cell: InitialFeatureCell, playVideoButtonClicked button: UIButton)
}
