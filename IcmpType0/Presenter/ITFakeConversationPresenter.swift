//
//  ITFakeConversationPresenter.swift
//  IcmpType0
//
//  Created by Franco Risma on 26/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class ITFakeConversationPresenter: ITConversationPresenterProtocol {
    
    private var viewDelegate: ITConversationViewControllerProtocol? {
        didSet {
            self.start()
        }
    }
    private var service = ITMessagingService.shared
    
    private var messagesArray = [Message]()
    
    // MARK: Retrieve conversation
    private func start() {
        self.service.getMessages(forConversation: "someConvId") { (messages, error) in
            if error != nil {
                self.viewDelegate?.showError(info: "Could not fetch previous messages")
                return
            } else {
                if !(messages?.isEmpty)! {
                    for aMessage in messages! {
                        self.messagesArray.append(aMessage)
                        if aMessage.userName == "Franco Risma" {
                            switch aMessage.type {
                            case .text:
                                    self.viewDelegate?.messageSent(message: String(data: aMessage.rawData, encoding: .utf8)!)
                            case .image:
                                self.viewDelegate?.messageSent(message: UIImage(data: aMessage.rawData)!)
                            }
                        } else {
                            switch aMessage.type {
                            case .text:
                                self.viewDelegate?.messageReceived(message: String(data: aMessage.rawData, encoding: .utf8)!)
                            case .image:
                                self.viewDelegate?.messageReceived(message: UIImage(data: aMessage.rawData)!)
                            }
                        }
                    }
                } else {
                    self.viewDelegate?.showError(info: "There is no history for this conversation")
                }
            }
        }
    }
    
    // MARK: ITConversationPresenterProtocol
    func setViewDelegate(delegate: ITConversationViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func sendMessage(text: String) {
        self.viewDelegate?.showError(info: "New messages are disabled for fake chats")
    }
    
    func sendMessage(image: UIImage) {
        self.viewDelegate?.showError(info: "New messages are disabled for fake chats")
    }
    
    func messageDetails(messageId: Int) {
        let isIndexValid = messagesArray.indices.contains(messageId)
        if isIndexValid {
            let selectedMessage = messagesArray[messageId]
            switch selectedMessage.type {
            case .image:
                self.viewDelegate?.showImageDetails(forMessage: selectedMessage)
            case .text:
                self.viewDelegate?.showTextDetails(forMessage: selectedMessage)
            }
        } else {
            self.viewDelegate?.showError(info: "Could not load details for message")
        }
    }
}

