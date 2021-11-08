//
//  PhoneNumber.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/10/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Phone number.
internal struct PhoneNumber {

    // MARK: - Internal -
    // MARK: Properties

    /// Country code.
    internal private(set) var countryISDNumber: String

    /// Phone number.
    internal private(set) var number: String

    // MARK: Methods

    internal static func == (left: PhoneNumber, right: PhoneNumber?) -> Bool {

        guard let nonnullRight = right else { return false }

        return left.countryISDNumber == nonnullRight.countryISDNumber && left.number == nonnullRight.number
    }
}
