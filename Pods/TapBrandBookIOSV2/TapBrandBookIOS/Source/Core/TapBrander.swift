//
//  TapBrander.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

public protocol TapBranderClass {
    
    associatedtype UIElement: TapBrandedClass
    
    static func brand(_ element: UIElement, with style: TapBrandingStyle)
}

public protocol TapBranderStruct {
    
    associatedtype UIElement: TapBrandedStruct
    
    static func brand(_ element: inout UIElement, with style: TapBrandingStyle)
}
