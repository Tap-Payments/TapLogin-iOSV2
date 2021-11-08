//
//  LoginNavigationController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/6/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapViewControllerV2
import UIKit

/// Root navigation controller of the Login Flow.
public class LoginNavigationController: TapNavigationController {

    // MARK: - Public -
    // MARK: Properties

    /// Defines if view hierarchy is loaded.
    public private(set) var viewHierarchyIsLoaded: Bool = false

    // MARK: Methods

    /// Instantiates new instance of LoginNavigationController.
    public static func instantiate() -> Self {

        guard let result = UIStoryboard.login.instantiateViewController(withIdentifier: self.tap_className) as? LoginNavigationController else {

            fatalError("Failed to load \(self.tap_className) from storyboard.")
        }

        return result.tap_asSelf()
    }

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.skipRegistrationFlowIfRequired()
    }

    public override func viewWillLayoutSubviews() {

        self.view.tap_stickToSuperview()
        super.viewWillLayoutSubviews()
    }

    // MARK: - Private -
    // MARK: Methods

    private func skipRegistrationFlowIfRequired() {

        if TapLogin.dataSource?.isLoggedIn ?? false {

            let loginStoryboard = UIStoryboard.login
            guard let loginContainerController = loginStoryboard.instantiateViewController(withIdentifier: LoginContainerViewController.tap_className) as? LoginContainerViewController else {

                fatalError("Failed to instantiate \(LoginContainerViewController.tap_className)")
            }

            loginContainerController.phoneNumberControllerKeyboardIsOpenedByDefault = false
            loginContainerController.tap_loadViewIfNotLoaded()

            self.pushViewController(loginContainerController, animated: false)

            TapLogin.delegate?.loginControllersAreLoadedIntoHierarchyWhenUserIsLoggedIn()
        } else {

            TapLogin.delegate?.loginControllersHierarchyIsNotLoadBecauseUserIsNotLoggedIn()
        }

        self.viewHierarchyIsLoaded = true
        NotificationCenter.default.post(name: .loginViewHierarchyIsLoaded, object: nil)
    }
}
