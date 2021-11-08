//
//  TapConfirmationCodeHandler.swift
//  TapLogin
//
//  Created by Philonenko Andrey on 23.01.2018.
//

import BlockUIViewControllerV2
import TapViewControllerV2

public class TapConfirmationCodeHandler {

    // MARK: - Public -
    // MARK: Methods

    public static func applyConfirmationCodeFromDeepLink(_ confirmationCode: String) -> Bool {

        guard (LoginData.lastUsed?.isCountryAvailable)! else { return false }
        guard TapLogin.dataSource?.storedPhoneNumber != nil else { return false }
        guard self.confirmationCodeValidationState(confirmationCode) == .valid else { return false }

        self.verify(confirmationCode)

        return true
    }

    // MARK: - Internal -

    internal struct Constants {

        internal static let loginConfirmationCodeRequiredLength = 6

        @available(*, unavailable) private init() {}
    }

    // MARK: Methods

    internal static func confirmationCodeValidationState(_ confirmationCode: String?) -> TapConfirmationCodeValidationState {

        if let nonnullConfirmationCode = confirmationCode {

            guard nonnullConfirmationCode.tap_containsOnlyInternationalDigits else { return .invalid }

            switch nonnullConfirmationCode.tap_length {

            case Constants.loginConfirmationCodeRequiredLength:

                return .valid

            case 0..<Constants.loginConfirmationCodeRequiredLength:

                return .incomplete

            default:

                return .invalid
            }

        } else {

            return .invalid
        }
    }

    // MARK: Methods

    @available(*, unavailable) private init() {}

    private static func verify(_ confirmationCode: String) {

        TapLoginRouter.showLoginConfirmationController(animated: false) { (confirmationController) in

            confirmationController.setConfirmationCodeFromURL(confirmationCode)
        }
    }
}
