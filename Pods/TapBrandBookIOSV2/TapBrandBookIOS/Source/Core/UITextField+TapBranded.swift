//
//  UITextField+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import UIKit


extension UITextField: TapBrandedClass {
    
    public func brandForTap(with style: TapBrandingStyle) {
        
        switch style {
            
        case .searchBar:
            
            self.defaultTextAttributes = self.searchBarBrandAttributes
            
        case .login:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(18.0, languageIdentifier: Locale.current.identifier)
            
        default:
            
            DebugLog("UITextField is not available for branding with \(style) style.")
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var searchBarBrandAttributes: [String: Any] {
        
        let result: [NSAttributedStringKey: Any] = [
            
            .font: TapFont.helveticaNeueRegular.localizedWithSize(17.0, languageIdentifier: Locale.current.identifier),
            .foregroundColor: UIColor.navigationBarTextColor
        ]
        
        return result.tap_mapKeys { $0.rawValue }
    }
}

public class UITextFieldBrander: TapBranderClass {
    
    public typealias UIElement = UITextField
    
    public static func brand(_ element: UITextField, with style: TapBrandingStyle) {
        
        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) private init() {}
}
