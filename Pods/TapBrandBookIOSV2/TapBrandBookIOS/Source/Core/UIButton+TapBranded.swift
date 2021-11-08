//
//  UIButton+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/11/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import UIKit

extension UIButton: TapBrandedClass {
    
    public func brandForTap(with style: TapBrandingStyle) {
        
        switch style {
            
        case .login:
            
            self.titleLabel?.font = TapFont.helveticaNeueLight.localizedWithSize(18.0,languageIdentifier: Locale.current.identifier)
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .highlighted)
            
        case .loginHeader:
            
            self.titleLabel?.font = TapFont.helveticaNeueRegular.localizedWithSize(17.0,languageIdentifier: Locale.current.identifier)
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .highlighted)
            
        case .welcomeStart:
            
            self.titleLabel?.font = TapFont.helveticaNeueLight.localizedWithSize(20.0,languageIdentifier: Locale.current.identifier)
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5), for: .highlighted)
            
        default:
            
            DebugLog("Style \(style) is not available for UIButton")
        }
    }
}

public class UIButtonBrander: TapBranderClass {
    
    public typealias UIElement = UIButton
    
    public static func brand(_ element: UIButton, with style: TapBrandingStyle) {
        
        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) private init() {}
}
