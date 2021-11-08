//
//  LoginData.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/10/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Login data.
public struct LoginData {

    // MARK: - Public -
    // MARK: Properties

    /// Phone number.
    internal private(set) var phoneNumber: PhoneNumber

    /// Timestamp of last sent SMS.
    internal var timestamp: TimeInterval

    /// Number of confirmation SMS that were sent.
    internal var numberOfSentSMS: UInt = 0

    /// Flag for country availability
    internal var isCountryAvailable: Bool?

    /// Last used login data during the application session.
    public static var lastUsed: LoginData?
}
