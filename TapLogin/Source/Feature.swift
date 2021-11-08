//
//  Feature.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class UIKit.UIImage.UIImage

/// Feature
public struct Feature {

    // MARK: - Public -
    // MARK: Properties

    /// Title.
    public let title: String

    /// Description.
    public let description: String

    /// Image.
    public let image: UIImage

    // MARK: Methods

    /// Initializes feature with title, description and an image.
    ///
    /// - Parameters:
    ///   - aTitle: Feature title.
    ///   - aDescription: Feature description.
    ///   - anImage: Feature image.
    public init(title aTitle: String, description aDescription: String, image anImage: UIImage) {

        self.title = aTitle
        self.description = aDescription
        self.image = anImage
    }
}
