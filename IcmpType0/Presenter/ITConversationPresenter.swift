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
    
    // MARK: ITConversationPresenterProtocol
    func setViewDelegate(delegate: ITConversationViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func sendMessage(text: String) {
        let sendingMessage = self.createSendingMessageFor(data: text.data(using: String.Encoding.utf8)!, type: .text)
        
        self.service.send(message: sendingMessage) { [weak self] (success) in
            
            if success {
                self?.viewDelegate?.messageSent(message: text)
                self?.messages.append(sendingMessage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let receivedMessage = self?.createReceivingMessageFor(data: text.data(using: String.Encoding.utf8)!, type: .text)
                    self?.messages.append(receivedMessage!)
                    self?.viewDelegate?.messageReceived(message: text)
                })
                
            } else {
                self?.viewDelegate?.showError(info: "Message could not be sent, please try again")
            }
        }
    }
    
    func sendMessage(image: UIImage) {
        let sendingMessage = self.createSendingMessageFor(data: UIImagePNGRepresentation(image)!, type: .image)
        
        self.service.send(message: sendingMessage) { [weak self] (success) in
            
            if success {
                self?.messages.append(sendingMessage)
                self?.viewDelegate?.messageSent(message: image)
                
                // Make the user receive the same message that it was sent
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    let receivedMessage = self?.createReceivingMessageFor(data: UIImagePNGRepresentation(image)!, type: .image)
                    self?.messages.append(receivedMessage!)
                    self?.viewDelegate?.messageReceived(message: image)
                })
                
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
    
    // MARK: Internal
    private func createSendingMessageFor(data: Data, type: MessageType) -> Message {
        let date = 02051987
        let uid = "1"
        
        return Message(type: type, rawData: data, date: date, userId: uid, userName: "Franco Risma")
    }
    
    private func createReceivingMessageFor(data: Data, type: MessageType) -> Message {
        let date = 02051987
        let uid = "999"
        
        return Message(type: type, rawData: data, date: date, userId: uid, userName: "The Bot")
    }
}
