//
//  TapLogin.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/6/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapApplicationV2
import TapLocalization_UIV2
import TapVideoManagerV2
import TapViewControllerV2

/// Tap Login Public Interface.
public class TapLogin {

    // MARK: Properties

    /// Appearance delegate. All view controllers appearance actions will be transferred through this delegate.
    public static weak var appearanceDelegate: ViewControllerAppearanceDelegate?

    /// Application interface.
    public static weak var applicationInterface: TapApplication?

    /// Login data source.
    public static weak var dataSource: TapLoginDataSource?

    /// Login delegate.
    public static weak var delegate: TapLoginDelegate?

    /// Language Selection View Controller Delegate.
    public static weak var languageSelectionViewControllerDelegate: LanguageSelectionViewControllerDelegate?

    /// Localization Data Source.
    public static weak var localizationDataSource: TapLoginLocalizationDataSource?

    /// APIs handler
    public static weak var apiHandler: LoginAPIsHandler?

    /// Video manager interface
    public static weak var videoManager: TapVideoManager?

    @available(*, unavailable) init() {}

    internal struct Constants {

        internal static let resendCodeTimeInSeconds: TimeInterval = 60.0
        @available(*, unavailable) private init() {}
    }
}
