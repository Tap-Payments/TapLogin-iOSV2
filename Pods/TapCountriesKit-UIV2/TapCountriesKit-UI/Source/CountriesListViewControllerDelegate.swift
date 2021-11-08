//
//  CountriesListViewControllerDelegate.swift
//  TapCountriesKit-UI
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapCountriesKitV2

/// Countries List View Controller Delegate
public protocol CountriesListViewControllerDelegate: class {

    // MARK: Methods

    /// Notifies delegate that countries list view controller did select a country and is about to close.
    ///
    /// - Parameters:
    ///   - countriesListViewController: Sender.
    ///   - country: Selected country.
    func countriesListViewController(_ countriesListViewController: CountriesListViewController, didFinishWith country: Country)
}
