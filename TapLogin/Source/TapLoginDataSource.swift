//
//  TapLoginDataSource.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import struct TapCountriesKitV2.Country
import class UIKit.UIImage.UIImage

public protocol TapLoginDataSource: ClassProtocol {

    // MARK: Properties

    /// Features
    var features: [Feature] { get }

    /// Defines if user is logged in.
    var isLoggedIn: Bool { get }

    /// Stored phone number.
    var storedPhoneNumber: String? { get }

    /// Stored country.
    var storedCountry: Country? { get }

    /// Initial feature cell image.
    var initialFeatureCellImage: UIImage { get }

    /// Logo for Country Unavailable screen ( 73x73pt ).
    var countryUnavailableScreenLogoImage: UIImage { get }
}
