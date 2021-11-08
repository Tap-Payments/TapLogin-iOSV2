//
//  TapColors.swift
//  TapBrandBookIOS
//
//  Created by Dennis Pashkov on 12/4/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

public extension UIColor {
    
    public static let navigationBarTextColor: UIColor = {
        
        guard let color = UIColor(tap_hex: "#343442") else {
            
            fatalError("Failed to create color from hex")
        }
        
        return color
    }()
}
