//
//  LoginAPIsHandler.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/10/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import struct TapAdditionsKitV2.TypeAlias
import struct TapCountriesKitV2.Country

public protocol LoginAPIsHandler: ClassProtocol {

    // MARK: Methods

    func callLoginAPI(with phoneNumber: String, country: Country, completion: @escaping TypeAlias.BooleanClosure)
    func callConfirmationAPI(with phoneNumber: String, confirmationCode: String, completion: @escaping TypeAlias.BooleanClosure)
    func resendConfirmationCode(_ completion: @escaping TypeAlias.BooleanClosure)
    func callComplaintAPI(with referenceID: String, completion: @escaping TypeAlias.BooleanClosure)
    func prioritizeCountry(_ completion: @escaping CountryUnavailableViewController.PrioritizationDetailsClosure)

    func usePhoneNumber(_ phoneNumber: String, country: Country)
}
