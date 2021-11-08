//
//  TapLoginDelegate.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

public protocol TapLoginDelegate: ClassProtocol {

    // MARK: Methods

    func loginConfirmationControllerResendCodeButtonClicked(_ controller: LoginConfirmationViewController)
    func loginConfirmationControllerDidFailToSendComplainceEmail(_ controller: LoginConfirmationViewController)
    func loginConfirmationControllerDeviceCannotSendMail(_ controller: LoginConfirmationViewController)

    func loginControllersAreLoadedIntoHierarchyWhenUserIsLoggedIn()
    func loginControllersHierarchyIsNotLoadBecauseUserIsNotLoggedIn()

    func featuresControllerFeatureScrolled()
}
