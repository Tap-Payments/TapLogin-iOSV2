//
//  LanguageSelectionViewControllerDelegate.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 12/5/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Language Selection View Controller Delegate.
public protocol LanguageSelectionViewControllerDelegate: ClassProtocol {

    // MARK: Methods

    /// Notifies the receiver that language selection view controller did select language.
    ///
    /// - Parameters:
    ///   - languageSelectionViewController: Sender
    ///   - language: Selected language identifier.
    func languageSelectionViewController(_ languageSelectionViewController: LanguageSelectionViewController, didSelect language: String)
}
