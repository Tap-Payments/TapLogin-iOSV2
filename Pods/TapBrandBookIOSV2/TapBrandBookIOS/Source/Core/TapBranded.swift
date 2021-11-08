//
//  TapBranded.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

/// Conforming to this protocol means that UI element is branded with Tap.
public protocol TapBrandedClass: ClassProtocol {
    
    // MARK: Methods
    
    /// Styles the element.
    func brandForTap(with style: TapBrandingStyle)
}

/// Conforming to this protocol means that UI element is branded with Tap.
public protocol TapBrandedStruct {
    
    // MARK: Methods
    
    /// Styles the element.
    mutating func brandForTap(with style: TapBrandingStyle)
}
