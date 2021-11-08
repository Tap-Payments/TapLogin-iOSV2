//
//  MailBody.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Mail body.
public struct MailBody {

    // MARK: - Public -
    // MARK: Properties

    /// Defines if mail body is HTML.
    public let isHTML: Bool

    /// Mail content.
    public let content: String

    // MARK: Methods

    /// Initializes MailBody with content and a flag which determines whether content is HTML.
    public init(content: String, isHTML: Bool) {

        self.content = content
        self.isHTML = isHTML
    }
}
