//
//  LanguageViewDelegate.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 1/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Delegate for LanguageViwe
@objc public protocol LanguageViewDelegate {

    // MARK: Methods

    /// Notifies delegate that language view was clicked.
    ///
    /// - Parameter languageView: Sender.
    func languageViewClicked(_ languageView: LanguageView)
}
