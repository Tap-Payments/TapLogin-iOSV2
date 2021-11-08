//
//  Notification.Name+Additions.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

public extension Notification.Name {

    // MARK: - Public -
    // MARK: Properties

    /// Notification name that is posted when login view hierarchy is loaded.
    public static let loginViewHierarchyIsLoaded = Notification.Name("loginViewHierarchyLoaded")

    /// Notification name that is being listened to update welcome screen info that welcome video URL has been loaded.
    public static let didLoadWelcomeVideoURLs = Notification.Name("didLoadWelcomeVideoURL")

    /// Notification name that is being listened to update welcome screen info that welcome video URL has failed to load.
    public static let didFailToLoadWelcomeVideoURLs = Notification.Name("didFailToLoadWelcomeVideoURLs")
}

public let tapLoginLoginViewHierarchyIsLoaded: Notification.Name = .loginViewHierarchyIsLoaded
public let tapLoginDidLoadWelcomeVideoURLs: Notification.Name = .didLoadWelcomeVideoURLs
public let tapLoginDidFailToLoadWelcomeVideoURLs: Notification.Name = .didFailToLoadWelcomeVideoURLs
