//
//  UINavigationBar+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import UIKit

extension UINavigationBar: TapBrandedClass {
    
    public func brandForTap(with style: TapBrandingStyle) {
        
        guard style == .default else {
            
            DebugLog("UINavigationBar can be branded only with default style.")
            return
        }
        
        self.titleTextAttributes = self.titleBrandAttributes
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var titleBrandAttributes: [NSAttributedStringKey: Any] {
        
        return [
            
            .font: TapFont.helveticaNeueRegular.localizedWithSize(17.0,languageIdentifier: Locale.current.identifier),
            .foregroundColor: UIColor.navigationBarTextColor
        ]
    }
}

public class UINavigationBarBrander: TapBranderClass {
    
    public typealias UIElement = UINavigationBar
    
    public static func brand(_ element: UINavigationBar, with style: TapBrandingStyle) {
        
        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) private init() {}
}
