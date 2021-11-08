//
//  MFMailComposeViewController+Additions.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class MessageUI.MFMailComposeViewController.MFMailComposeViewController

/// Useful extension to MFMailComposeViewController
internal extension MFMailComposeViewController {

    // MARK: - Internal -
    // MARK: Methods

    /// Adds attachment.
    internal func addAttachment(_ attachment: Attachment) {

        self.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
    }

    /// Adds attachments.
    internal func addAttachments(_ attachments: [Attachment]) {

        for attachment in attachments {

            self.addAttachment(attachment)
        }
    }

    /// Sets body.
    internal func setBody(_ body: MailBody) {

        self.setMessageBody(body.content, isHTML: body.isHTML)
    }
}
