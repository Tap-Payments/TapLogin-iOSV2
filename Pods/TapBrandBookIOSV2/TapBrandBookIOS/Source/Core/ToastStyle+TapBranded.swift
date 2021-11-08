//
//  ToastStyle+TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/12/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapFontsKitV2
import TapLoggerV2
import struct Toast_Swift.ToastStyle

extension ToastStyle: TapBrandedStruct {
    
    public mutating func brandForTap(with style: TapBrandingStyle) {
        
        guard style == .toast else {
            
            DebugLog("ToastStyle can be branded only with toast style.")
            return
        }
        
        self.messageFont = TapFont.helveticaNeueLight.localizedWithSize(16.0,languageIdentifier: Locale.current.identifier)
    }
}

public class ToastStyleBrander: TapBranderStruct {

    public typealias UIElement = ToastStyle
    
    public static func brand(_ element: inout ToastStyle, with style: TapBrandingStyle) {
        
        element.brandForTap(with: style)
    }
    
    @available(*, unavailable) init() {}
}
