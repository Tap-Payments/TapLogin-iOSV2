//
//  CountriesDataSource.swift
//  TapCountriesKit
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreTelephony
import TapDatabaseV2

/// Countries Data Source
public class CountriesDataSource {

    // MARK: - Public -

    /// Countries loading status.
    ///
    /// - notLoaded: Countries are not loaded.
    /// - loading: Countries are loading.
    /// - loaded: Countries have been loaded.
    public enum LoadingStatus {

        case notLoaded
        case loading
        case loaded
    }

    // MARK: Properties

    /// Shared instance.
    public static let shared = CountriesDataSource()

    /// Countries loading status.
    public private(set) lazy var status: LoadingStatus = .notLoaded

    /// List of all countries.
    public private(set) lazy var countries: [Country] = []

    /// List of all countries available for registration.
    public var countriesAvailableForRegistration: [Country] {

        return self.countries.filter { $0.canBeUsedForRegistration }
    }

    /// Country of SIM card installed in the device.
    public var simCardCountry: Country? {

        guard let isoCountryCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode else { return nil }
        return self.country(withISOCode: isoCountryCode)
    }

    /// Primary country based on user's current locale (device locale, not the app one).
    public var deviceLocaleRegionCountry: Country? {

        guard let regionISOCode = Locale.current.regionCode else { return nil }
        return self.country(withISOCode: regionISOCode)
    }

    // MARK: Methods

    /// Preloads countries.
    public static func preload() {

        _ = self.shared
    }

    /// Returns country with a given ISO code if found.
    ///
    /// - Parameter code: Two or three-lettered ISO country code.
    /// - Returns: Country if found, nil otherwise.
    public func country(withISOCode code: String) -> Country? {

        let uppercasedCode = code.uppercased()

        let resultingCountries = self.countries.filter { $0.isoCode.twoLetters.uppercased() == uppercasedCode || $0.isoCode.threeLetters.uppercased() == uppercasedCode }
        return resultingCountries.first
    }

    /// Returns country with a given ISD number if found.
    ///
    /// - Parameter isdNumber: ISD number.
    /// - Returns: Country if found, nil otherwise.
    public func country(withISDNumber isdNumber: Int) -> Country? {

        let resultingCountries = self.countries.filter { $0.isdNumber == isdNumber }
        return resultingCountries.first
    }

    // MARK: - Private -
    // MARK: Properties

    fileprivate typealias CountriesType = [[String: Any]]

    // MARK: Methods

    private init() {

        self.setup()
    }

    private func setup() {

        self.status = .loading
        NotificationCenter.default.post(name: .countriesDidStartLoading, object: nil)
        TapDatabase.shared.addObserver(self)
    }
}

// MARK: - TapDatabaseObserver
extension CountriesDataSource: TapDatabaseObserver {

    public var paths: [DatabasePath] {

        return [TapDatabase.Path.countries]
    }

    public func valueChanged(_ value: Any, at path: DatabasePath) {

        if path == TapDatabase.Path.countries {

            if let countriesData = value as? CountriesType {

                self.countries = countriesData.compactMap { Country(dictionary: $0) }
                self.status = .loaded

                NotificationCenter.default.post(name: .countriesDidFinishLoading, object: nil)
            }
        }
    }

    public func valueDisappeared(at path: DatabasePath) {

        if path == TapDatabase.Path.countries {

            self.countries = []
            self.status = .notLoaded

            NotificationCenter.default.post(name: .countriesDidFailLoading, object: nil)
        }
    }
}
