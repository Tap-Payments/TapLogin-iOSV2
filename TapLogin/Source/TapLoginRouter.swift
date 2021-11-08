//
//  TapLoginRouter.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 1/23/18.
//

import struct TapAdditionsKitV2.TypeAlias
import class TapViewControllerV2.ContainerPopupViewController

/// Class for routing inside TapLogin module.
public class TapLoginRouter {

    // MARK: - Public -
    // MARK: Properties

    /// Defines if login flow view hierarchy is loaded.
    public static var isViewHierarchyLoaded: Bool {

        return LoginNavigationController.tap_findInHierarchy()?.viewHierarchyIsLoaded ?? false
    }

    // MARK: Methods

    /// Shows login navigation controller ( if not yet shown ).
    public static func showLoginNavigationController(_ completion: ((LoginNavigationController) -> Void)? = nil) {

        if let existingController = LoginNavigationController.tap_findInHierarchy() {

            completion?(existingController)
            return
        }

        let loginNavigationContainerController = ContainerPopupViewController.instantiate()
        let loginNavigationController = LoginNavigationController.instantiate()

        loginNavigationContainerController.show(animated: false) { [weak loginNavigationContainerController] in

            loginNavigationController.modalPresentationStyle = .overCurrentContext
            loginNavigationContainerController?.present(loginNavigationController, animated: false) {

                completion?(loginNavigationController)
            }
        }
    }

    // MARK: - Internal -
    // MARK: Methods

    internal static func showLoginContainerController(animated: Bool = true, completion: ((LoginContainerViewController) -> Void)? = nil) {

        if let existingController = LoginContainerViewController.tap_findInHierarchy() {

            completion?(existingController)
            return
        }

        self.showLoginNavigationController { loginNavigationController in

            let loginContainerViewController = LoginContainerViewController.instantiate()

            DispatchQueue.main.async {

                loginNavigationController.tap_pushViewController(loginContainerViewController, animated: animated) {

                    completion?(loginContainerViewController)
                }
            }
        }
    }

    internal static func showLoginConfirmationController(animated: Bool = true, completion: ((LoginConfirmationViewController) -> Void)? = nil) {

        if let existingController = LoginConfirmationViewController.tap_findInHierarchy() {

            completion?(existingController)
            return
        }

        self.showLoginContainerController(animated: animated) { loginContainerController in

            loginContainerController.tap_loadViewIfNotLoaded()

            let contentNavigationController = loginContainerController.contentNavigationController

            let confirmationController = LoginConfirmationViewController.instantiate()
            confirmationController.parentContainerController = loginContainerController

            DispatchQueue.main.async {

                contentNavigationController?.tap_pushViewController(confirmationController, animated: animated) {

                    completion?(confirmationController)
                }
            }
        }
    }

    // MARK: - Private -
    // MARK: Methods

    @available(*, unavailable) private init() {}
}
