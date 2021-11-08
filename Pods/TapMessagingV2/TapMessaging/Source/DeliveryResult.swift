//
//  DeliveryResult.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

public enum DeliveryResult {

    case sent
    case cancelled
    case failed(Error?)
}
