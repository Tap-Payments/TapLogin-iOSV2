//
//  LoginNavigationControllerDelegate.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/14/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapViewControllerV2
import UIKit

/// Login Navigation controller delegate.
internal class LoginNavigationControllerDelegate: NSObject { }

// MARK: - UINavigationControllerDelegate
extension LoginNavigationControllerDelegate: UINavigationControllerDelegate {

    // MARK: - Internal -
    // MARK: Methods

    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return NavigationControllerOldSchoolTransitionAnimation(operation: operation)
    }
}
