//
//  TapMessaging.swift
//  TapMessaging
//
//  Created by Dennis Pashkov on 12/26/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2
import MessageUI
import UIKit

/// Tap Messaging class.
public class TapMessaging: NSObject {

    // MARK: - Public -

    public typealias DeliveryResultClosure = (DeliveryResult) -> Void

    // MARK: Properties

    /// Shared instance.
    public static let shared = TapMessaging()

    /// Defines if emails can be sent from current device.
    public var canSendMail: Bool {

        return MFMailComposeViewController.canSendMail()
    }

    /// Defines is SMS can be sent from current device.
    public var canSendSMSText: Bool {

        return MFMessageComposeViewController.canSendText()
    }

    /// Defines if current device can send SMS subject.
    public var canSendSMSSubject: Bool {

        return MFMessageComposeViewController.canSendSubject()
    }

    /// Defines if current device can send SMS attachments.
    public var canSendSMSAttachments: Bool {

        return MFMessageComposeViewController.canSendAttachments()
    }

    // MARK: Methods

    /// Shows mail compose controller with the given parameters.
    ///
    /// - Parameters:
    ///   - subject: Mail subject.
    ///   - recipients: Mail recipients.
    ///   - body: Mail body.
    ///   - attachments: Mail attachment (if any).
    ///   - completion: Completion closure that is called after mail compose controller is closed.
    public func showMailComposeController(with subject: String?, recipients: [String]?, body: MailBody, attachments: [Attachment]?, completion: @escaping DeliveryResultClosure) {

        guard self.canSendMail else {

            completion(.failed(nil))
            return
        }

        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self

        if let nonnullSubject = subject {

            controller.setSubject(nonnullSubject)
        }

        controller.setToRecipients(recipients)
        controller.setBody(body)

        if let nonnullAttachments = attachments {

            controller.addAttachments(nonnullAttachments)
        }

        self.callbacks[controller.description] = completion

        DispatchQueue.main.async {

            (controller as UIViewController).tap_className
        }
    }

    /// Shows message compose controller with the given parameters.
    ///
    /// - Parameters:
    ///   - subject: Message subject.
    ///   - recipients: Message recipients.
    ///   - body: Message body.
    ///   - attachments: Message attachment (if any).
    ///   - completion: Completion closure that is called after message compose controller is closed.
    public func showMessageComposeController(with subject: String?, recipients: [String]?, body: String, attachments: [Attachment]?, completion: @escaping DeliveryResultClosure) {

        guard self.canSendSMSText else {

            completion(.failed(nil))
            return
        }

        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = self
        controller.recipients = recipients
        controller.body = body

        if self.canSendSMSSubject {

            controller.subject = subject
        }

        if let nonnullAttachments = attachments, self.canSendSMSAttachments {

            controller.addAttachments(nonnullAttachments)
        }

        self.callbacks[controller.description] = completion

        DispatchQueue.main.async {
            let controllerr:UIViewController = .init()
            controllerr.tap_currentPresentedViewController?.present(controller, animated: true, completion: nil)
            //controllerr.tap
            //controller.tap_show//showOnSeparateWindow(true, completion: nil)
        }
    }

    // MARK: - Private -
    // MARK: Properties

    private lazy var callbacks: [String: DeliveryResultClosure] = [:]

    // MARK: Methods

    private override init() { super.init() }

    private func messagingController(_ controller: UIViewController, didFinishWith result: DeliveryResult) {

        let key = controller.description
        guard let completion = self.callbacks[key] else { return }
        
        controller.tap_dismissFromSeparateWindow(true) {

            completion(result)
            self.callbacks.removeValue(forKey: key)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension TapMessaging: MFMailComposeViewControllerDelegate {

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        var deliveryResult: DeliveryResult
        switch result {

        case .cancelled, .saved:

            deliveryResult = .cancelled

        case .sent:

            deliveryResult = .sent

        case .failed:

            deliveryResult = .failed(error)
        }

        self.messagingController(controller, didFinishWith: deliveryResult)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate
extension TapMessaging: MFMessageComposeViewControllerDelegate {

    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {

        var deliveryResult: DeliveryResult
        switch result {

        case .cancelled:

            deliveryResult = .cancelled

        case .sent:

            deliveryResult = .sent

        case .failed:

            deliveryResult = .failed(nil)
        }

        self.messagingController(controller, didFinishWith: deliveryResult)
    }
}
