//
//  UIBarButtonItem+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import UIKit
import TapAdditionsKitV2

extension UIBarButtonItem: TapBrandedClass {
    
    // MARK: - Public -
    // MARK: Methods
    
    public func brandForTap(with style: TapBrandingStyle) {
        
        switch style {
            
        case .navigationBar:
            
            let attributes = self.navigationBarBrandedAttributes
            
            self.setTitleTextAttributes(attributes, for: .normal)
            self.setTitleTextAttributes(attributes, for: .highlighted)
            break
            
        case .searchBar:
           
            let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
                
                let attributes = self.searchBarBrandedAttributes
                
                appearance.setTitleTextAttributes(attributes, for: .normal)
                appearance.setTitleTextAttributes(attributes, for: .highlighted)
            
            
            break
            
        default:
            
            DebugLog("Style \(style) is not available for UIBarButtonItem")
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var navigationBarBrandedAttributes: [NSAttributedStringKey: Any] {
        
        return [
            
            .font: TapFont.helveticaNeueRegular.localizedWithSize(17.0, languageIdentifier: Locale.current.identifier),
            .foregroundColor: UIColor.navigationBarTextColor
        ]
    }
    
    private var searchBarBrandedAttributes: [NSAttributedStringKey: Any] {
        
        return [
            
            .font: TapFont.helveticaNeueRegular.localizedWithSize(15.0, languageIdentifier: Locale.current.identifier),
            .foregroundColor: UIColor.navigationBarTextColor
        ]
    }
}

public class UIBarButtonItemBrander: TapBranderClass {
    
    public typealias UIElement = UIBarButtonItem
    
    public static func brand(_ element: UIBarButtonItem, with style: TapBrandingStyle) {

        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) private init() {}
}
