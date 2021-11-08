//
//  Country.swift
//  TapCountriesKit
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFlagsKitV2
import TapLocalizationV2
import UIKit

/// Country model.
public struct Country {

    // MARK: - Public -

    /// ISO code model
    public struct ISOCode {

        /// Two letters ISO code.
        public let twoLetters: String

        /// Three letters ISO code.
        public let threeLetters: String
    }

    // MARK: Properties

    /// ISD number.
    public let isdNumber: Int

    /// Displayed ISD number, e.g. "+965"
    public var displayedISDNumber: String {

        return String(format: "+%ld", locale: .tap_enUS, self.isdNumber)
    }

    /// ISO code.
    public let isoCode: ISOCode

    /// Regular expression for phone number validation.
    public let phoneNumberPattern: String?

    /// Regular expression for ID number validation.
    public let idPattern: String?

    /// Returns localized country name.
    public var localizedName: String {

        return LocalizationManager.shared.locale.localizedString(forRegionCode: self.isoCode.twoLetters) ?? .tap_empty
    }

    /// Returns country name in English language.
    public var internationalName: String {

        return Locale.tap_enUS.localizedString(forRegionCode: self.isoCode.twoLetters) ?? .tap_empty
    }

    /// Defines if the receiver can be used for registration.
    public var canBeUsedForRegistration: Bool = true

    /// Defines if the receiver can be used for adding mobile.
    public var canBeUsedForAddingMobile: Bool = true

    /// Defines if the receiver can be used for adding ID.
    public var canBeUsedForAddingID: Bool = true

    /// Flag image.
    public var flagImage: UIImage? {

        return TapFlagsKit.flag(for: self.isoCode.twoLetters)
    }

    /// Returns dictionary representation of the receiver.
    public var dictionaryRepresentation: [String: Any] {

        var result: [String: Any] = [:]

        result[Constants.isdNumberKey] = self.isdNumber
        result[Constants.twoLettersISOCodeKey] = self.isoCode.twoLetters
        result[Constants.threeLettersISOCodeKey] = self.isoCode.threeLetters
        result[Constants.canRegisterKey] = self.canBeUsedForRegistration
        result[Constants.canAddMobileKey] = self.canBeUsedForAddingMobile
        result[Constants.canAddCivilIDKey] = self.canBeUsedForAddingID

        if let phoneNumberPattern = self.phoneNumberPattern {

            result[Constants.phoneNumberPatternKey] = phoneNumberPattern
        }

        if let idNumberPattern = self.idPattern {

            result[Constants.idPatternKey] = idNumberPattern
        }

        return result
    }

    // MARK: Methods

    /// Initializes country with ISD number, ISO code, optionally with phone number pattern and ID pattern.
    ///
    /// - Parameters:
    ///   - isdNumber: ISD number.
    ///   - twoLettersISOCode: Two letters ISO code.
    ///   - threeLettersISOCode: Three letters ISO code.
    ///   - phoneNumberPattern: Phone number pattern.
    ///   - idPattern: ID pattern.
    ///   - canBeUsedForRegistration: Defines if country can be used for registration.
    ///   - canBeUsedForAddingMobile: Defines if country can be used for adding mobile.
    ///   - canBeUsedForAddingID: Defines if country can be used for adding ID.
    public init(isdNumber: Int, twoLettersISOCode: String, threeLettersISOCode: String, phoneNumberPattern: String? = nil, idPattern: String? = nil, canBeUsedForRegistration: Bool = true, canBeUsedForAddingMobile: Bool = true, canBeUsedForAddingID: Bool = true) {

        self.isdNumber = isdNumber
        self.isoCode = ISOCode(twoLetters: twoLettersISOCode, threeLetters: threeLettersISOCode)
        self.phoneNumberPattern = phoneNumberPattern
        self.idPattern = idPattern
        self.canBeUsedForRegistration = canBeUsedForRegistration
        self.canBeUsedForAddingMobile = canBeUsedForAddingMobile
        self.canBeUsedForAddingID = canBeUsedForAddingID
    }

    // MARK: - Internal -
    // MARK: Methods

    /// Initializes country with contents of Firebase dictionary.
    ///
    /// - Parameter dictionary: Dictionary.
    internal init?(dictionary: [String: Any]) {

        guard let isdNumber = dictionary[Constants.isdNumberKey] as? Int else { return nil }
        guard let isoCode2 = dictionary[Constants.twoLettersISOCodeKey] as? String,
              let isoCode3 = dictionary[Constants.threeLettersISOCodeKey] as? String else { return nil }

        self.init(isdNumber: isdNumber,
                  twoLettersISOCode: isoCode2,
                  threeLettersISOCode: isoCode3,
                  phoneNumberPattern: dictionary[Constants.phoneNumberPatternKey] as? String,
                  idPattern: dictionary[Constants.idPatternKey] as? String,
                  canBeUsedForRegistration: dictionary[Constants.canRegisterKey] as? Bool ?? true,
                  canBeUsedForAddingMobile: dictionary[Constants.canAddMobileKey] as? Bool ?? true,
                  canBeUsedForAddingID: dictionary[Constants.canAddCivilIDKey] as? Bool ?? true)
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let isdNumberKey = "ISD_Number"
        fileprivate static let twoLettersISOCodeKey = "Two_Letter_ISO_Code"
        fileprivate static let threeLettersISOCodeKey = "Three_Letter_ISO_Code"
        fileprivate static let phoneNumberPatternKey = "Phone_Number_Validation"
        fileprivate static let idPatternKey = "Civil_Id_Validation"
        fileprivate static let canAddCivilIDKey = "Can_Add_Civil_Id"
        fileprivate static let canAddMobileKey = "Can_Add_Mobile"
        fileprivate static let canRegisterKey = "Can_Register"

        @available(*, unavailable) private init() {}
    }
}

// MARK: - Equatable
extension Country: Equatable {

    public static func == (lhs: Country, rhs: Country) -> Bool {

        return lhs.isoCode.twoLetters == rhs.isoCode.twoLetters
    }
}
