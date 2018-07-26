//
//  ITConversationPresenter.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class ITConversationPresenter: ITConversationPresenterProtocol {

    private var viewDelegate: ITConversationViewControllerProtocol?
    private var service = ITMessagingService.shared
    
    private var messages = [Message]()
    
    // MARK: Initialization
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(received(notification:)), name: .kITNotificationMessageReceived, object: nil)
    }
    
    // MARK: ITConversationPresenterProtocol
    func setViewDelegate(delegate: ITConversationViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func sendMessage(text: String) {
        let sendingMessage = self.createSendingMessageFor(data: text.data(using: .utf8)!, type: .text)
        
        self.service.send(message: sendingMessage) { [weak self] (error) in
            if error == nil {
                self?.viewDelegate?.messageSent(message: text)
                self?.messages.append(sendingMessage)
            } else {
                self?.viewDelegate?.showError(info: "Message could not be sent, please try again")
            }
        }
    }
    
    func sendMessage(image: UIImage) {
        let sendingMessage = self.createSendingMessageFor(data: UIImagePNGRepresentation(image)!, type: .image)
        self.service.send(message: sendingMessage) { [weak self] (error) in
            if error == nil {
                self?.messages.append(sendingMessage)
                self?.viewDelegate?.messageSent(message: image)
            } else {
                self?.viewDelegate?.showError(info: "Message could not be sent, please try again")
            }
        }
    }
    
    func messageDetails(messageId: Int) {
        let isIndexValid = messages.indices.contains(messageId)
        if isIndexValid {
            let selectedMessage = messages[messageId]
            switch selectedMessage.type {
            case .image:
                self.viewDelegate?.showImageDetails(forMessage: selectedMessage)
            case .text:
                self.viewDelegate?.showTextDetails(forMessage: selectedMessage)
            }
        } else {
            print("Message not found")
        }
    }
    
    // MARK: Notifications (for new messages)
    @objc private func received(notification: NSNotification) {
        if let data = notification.userInfo as? [String: Message] {
            for (_, message) in data {
                self.messages.append(message)
                switch message.type {
                case .text:
                    self.viewDelegate?.messageReceived(message: String(data: message.rawData, encoding: .utf8)!)
                    break
                case .image:
                    self.viewDelegate?.messageReceived(message: UIImage(data: message.rawData)!)
                    break
                }
            }
        }
    }
    
    // MARK: Internal
    private func createSendingMessageFor(data: Data, type: MessageType) -> Message {
        let uid = "1"
        return Message(type: type, rawData: data, date: Date(), userId: uid, userName: "Franco Risma")
    }
}
