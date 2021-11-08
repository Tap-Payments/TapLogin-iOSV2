//
//  MFMessageComposeViewController+Additions.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import class MessageUI.MFMessageComposeViewController.MFMessageComposeViewController

/// Useful extension for MFMessageComposeViewController.
internal extension MFMessageComposeViewController {

    // MARK: - Internal -
    // MARK: Methods.

    /// Adds attachment.
    internal func addAttachment(_ attachment: Attachment) {

        guard MFMessageComposeViewController.isSupportedAttachmentUTI(attachment.mimeType) else { return }

        self.addAttachmentData(attachment.data, typeIdentifier: attachment.mimeType, filename: attachment.fileName)
    }

    /// Adds attachments.
    internal func addAttachments(_ attachments: [Attachment]) {

        for attachment in attachments {

            self.addAttachment(attachment)
        }
    }
}
