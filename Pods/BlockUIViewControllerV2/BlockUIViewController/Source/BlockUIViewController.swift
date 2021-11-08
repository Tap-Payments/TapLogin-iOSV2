//
//  BlockUIViewController.swift
//  BlockUIViewController
//
//  Created by Dennis Pashkov on 12/10/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2
import TapGLKitV2
import TapSwiftFixesV2
import TapViewControllerV2
import UIKit

/// Block UI controller.
public class BlockUIViewController: PopupViewController {

    // MARK: - Public -
    // MARK: Methods

    /*!
     Blocks UI.
     */
    public static func blockUI(_ completion: @escaping TypeAlias.ArgumentlessClosure) {

        self.blockUI(withUserInteractionEnabled: true,
                     backgroundColor: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6),
                     activityIndicatorColor: UIColor.white,
                     completion: completion)
    }

    /*!
     Blocks UI with parameters.
 
     - parameter userInteractionEnabled: Defines if touches are passed.
     - parameter backgroundColor:        Background color.
     - parameter activityIndicatorColor: Activity indicator color.
     */
    public static func blockUI(withUserInteractionEnabled userInteractionEnabled: Bool, backgroundColor: UIColor?, activityIndicatorColor: UIColor?, completion: @escaping TypeAlias.ArgumentlessClosure) {

        self.blockUI(withUserInteractionEnabled: userInteractionEnabled, backgroundColor: backgroundColor, activityIndicatorColor: activityIndicatorColor, statusBarStyle: .lightContent, completion: completion)
    }

    /*!
     Blocks UI with parameters.
 
     - parameter userInteractionEnabled: Defines if touches are passed.
     - parameter backgroundColor:        Background color.
     - parameter activityIndicatorColor: Activity indicator color.
     - parameter statusBarStyle: Status bar style.
     */
    public static func blockUI(withUserInteractionEnabled userInteractionEnabled: Bool, backgroundColor: UIColor?, activityIndicatorColor: UIColor?, statusBarStyle: UIStatusBarStyle, completion: @escaping TypeAlias.ArgumentlessClosure) {

        self.show(withUserInteractionEnabled: userInteractionEnabled, backgroundColor: backgroundColor, activityIndicatorColor: activityIndicatorColor, statusBarStyle: statusBarStyle, completion: completion)
    }

    /*!
     Unblocks UI and calls completion block when finished.
 
     - parameter completion: Completion block to be called.
     */
    public static func unblockUI(_ completion: TypeAlias.ArgumentlessClosure?) {

        self.hide(with: completion)
    }

    public override class func instantiate() -> Self {

        let controller = BlockUIViewController(nibName: self.tap_className, bundle: .blockUIControllerResourcesBundle)
        controller.affectsAppearanceMethods = false

        return controller.tap_asSelf()
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var activityIndicator: TapActivityIndicatorView?

    private static var appearanceCounter: Int {

        get {

            return synchronized(self._appearanceCounter) { return self._appearanceCounter }
        }
        set {

            synchronized(self._appearanceCounter) { self._appearanceCounter = newValue }
        }
    }

    private static var _appearanceCounter: Int = 0

    private static var completions: [TypeAlias.ArgumentlessClosure] = []

    private static weak var instance: BlockUIViewController?

    // MARK: Methods

    private static func show(withUserInteractionEnabled userInteractionEnabled: Bool, backgroundColor: UIColor?, activityIndicatorColor: UIColor?, statusBarStyle: UIStatusBarStyle, completion: @escaping TypeAlias.ArgumentlessClosure) {

        synchronized(self) {

            let blockUIController = self.instance ?? BlockUIViewController.instantiate()
            self.instance = blockUIController

            blockUIController.didMoveToSuperviewClosure = { [weak blockUIController] in

                blockUIController?.view.window?.isUserInteractionEnabled = userInteractionEnabled
            }

            blockUIController.restoresPreviousFirstResponder = false
            blockUIController.tap_loadViewIfNotLoaded()

            blockUIController.view.backgroundColor = backgroundColor

            if activityIndicatorColor == nil {

                blockUIController.activityIndicator?.usesCustomColors = false
            } else {

                blockUIController.activityIndicator?.usesCustomColors = true
                blockUIController.activityIndicator?.outterCircleColor = activityIndicatorColor!
                blockUIController.activityIndicator?.innerCircleColor = activityIndicatorColor!
            }

            blockUIController.statusBarStyle = statusBarStyle

            self.appearanceCounter += 1

            blockUIController.show(animated: true, completion: completion)
        }
    }

    private static func hide(with completion: TypeAlias.ArgumentlessClosure?) {

        synchronized(self) {

            self.appendCompletion(completion)

            guard self.appearanceCounter > 0 else {

                DispatchQueue.main.async {

                    self.callCompletionsAndEmptyCompletionsStack()
                }

                return
            }

            guard let blockUIController = self.instance else {

                DispatchQueue.main.async {

                    self.callCompletionsAndEmptyCompletionsStack()
                }

                return
            }

            self.appearanceCounter -= 1

            guard self.appearanceCounter == 0 else {

                DispatchQueue.main.async {

                    self.callCompletionsAndEmptyCompletionsStack()
                }

                return
            }

            blockUIController.hide(animated: true) {

                self.callCompletionsAndEmptyCompletionsStack()
            }

            self.instance = nil
        }
    }

    private static func appendCompletion(_ completion: TypeAlias.ArgumentlessClosure?) {

        if let nonnullCompletion = completion {

            synchronized(self.completions) {

                self.completions.append(nonnullCompletion)
            }
        }
    }

    private static func callCompletionsAndEmptyCompletionsStack() {

        synchronized(self.completions) {

            for completion in completions.reversed() {

                completion()
            }

            self.completions.removeAll()
        }
    }
}
