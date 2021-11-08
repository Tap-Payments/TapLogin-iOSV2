//
//  Notification.Name+Additions.swift
//  TapCountriesKit
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Handy extension to Notification.Name
public extension Notification.Name {

    // MARK: - Public -
    // MARK: Properties

    /// Notification name for notification that is fired when countries list starts loading.
    public static let countriesDidStartLoading = Notification.Name("CountriesDidStartLoading")

    /// Notification name for notification that is fired when countries list has finished loading.
    public static let countriesDidFinishLoading = Notification.Name("CountriesDidFinishLoading")

    /// Notification name for notification that is fired when countries list has failed loading.
    public static let countriesDidFailLoading = Notification.Name("CountriesDidFailLoading")
}

/// Top level constants to avoid import of the whole module.

public let tapCountriesKitCountriesDidStartLoading: Notification.Name = .countriesDidStartLoading
public let tapCountriesKitCountriesDidFinishLoading: Notification.Name = .countriesDidFinishLoading
public let tapCountriesKitCountriesDidFailLoading: Notification.Name = .countriesDidFailLoading
