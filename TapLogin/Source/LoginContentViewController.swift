//
//  LoginContentViewController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 3/17/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapViewControllerV2

/// Login Content View Controller.
public class LoginContentViewController: TapViewController {

    // MARK: - Public -
    // MARK: Properties

    /// Parent container controller.
    public weak var parentContainerController: LoginContainerViewController?

    public override var title: String? {

        didSet {

            self.parentContainerController?.titleText = self.title ?? String.tap_empty
        }
    }

    /// Defines if next button is enabled.
    public var isNextButtonEnabled: Bool = false {

        didSet {

            self.parentContainerController?.isNextButtonEnabled = self.isNextButtonEnabled
        }
    }

    // MARK: - Internal -
    // MARK: Methods

    /// Handles click of next button.
    internal func handleNextButtonClick() {

        fatalError("Should be implemented in subclasses.")
    }
}
