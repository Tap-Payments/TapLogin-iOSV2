//
//  UILabel+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/11/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import UIKit

extension UILabel: TapBrandedClass {
    
    // MARK: - Public -
    // MARK: Methods
    
    public func brandForTap(with style: TapBrandingStyle) {
        
        switch style {
            
        case .login:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(14.0,languageIdentifier: Locale.current.identifier)
            self.textColor = self.loginTextColor
            
        case .loginHeader:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(27.0,languageIdentifier: Locale.current.identifier)
            self.textColor = .white
            
        case .welcomeFeatureTitle:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(27.0,languageIdentifier: Locale.current.identifier)
            self.textColor = .white
            
        case .welcomeFeatureSubtitle:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(18.0,languageIdentifier: Locale.current.identifier)
            self.textColor = .white
            
        case .versionText:
            
            self.font = TapFont.helveticaNeueLight.localizedWithSize(11.0,languageIdentifier: Locale.current.identifier)
            self.textColor = .white
            
        default:
            
            DebugLog("Style \(style) is not available for UILabel")
            break
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var loginTextColor: UIColor {
        
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
    }
}

public class UILabelBrander: TapBranderClass {
    
    public typealias UIElement = UILabel
    
    public static func brand(_ element: UILabel, with style: TapBrandingStyle) {
        
        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) private init() {}
}
