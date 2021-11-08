//
//  Attachment.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

/// Mail/Message attachment.
public struct Attachment {

    // MARK: - Public -
    // MARK: Properties

    /// Attachment data.
    public let data: Data

    /// Attachment mime type.
    public let mimeType: String

    /// Attachment file name.
    public let fileName: String

    // MARK: Methods

    /// Constructor.
    public init(data: Data, mimeType: String, fileName: String) {

        self.data = data
        self.mimeType = mimeType
        self.fileName = fileName
    }
}
