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
    
    private var messagesSent = [Message]()
    private var messagesReceived = [Message]()
    
    // MARK: ITConversationPresenterProtocol
    func setViewDelegate(delegate: ITConversationViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func cameraButtonTapped() {
        
    }
    
    func sendMessage(text: String) {
        let sendingMessage = self.createSendingMessageFor(data: text.data(using: String.Encoding.utf8)!, type: .text)
        
        self.service.send(message: sendingMessage) { [weak self] (success) in
            
            if success {
                self?.viewDelegate?.messageSent(message: text)
                self?.messagesSent.append(sendingMessage)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    let receivedMessage = self?.createReceivingMessageFor(data: text.data(using: String.Encoding.utf8)!, type: .text)
                    self?.messagesReceived.append(receivedMessage!)
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
                self?.messagesSent.append(sendingMessage)
                self?.viewDelegate?.messageSent(message: image)
                
                // Make the user receive the same message that it was sent
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    let receivedMessage = self?.createReceivingMessageFor(data: UIImagePNGRepresentation(image)!, type: .image)
                    self?.messagesReceived.append(receivedMessage!)
                    self?.viewDelegate?.messageReceived(message: image)
                })
                
            } else {
                self?.viewDelegate?.showError(info: "Message could not be sent, please try again")
            }
        }
        
        
    }
    
    func messageDetails(messageId: String) {
        var theMessage: Message?
        if !messagesReceived.isEmpty {
            for aMessage in messagesReceived {
                if aMessage.id == messageId {
                    theMessage = aMessage
                    break;
                }
            }
        }
        if theMessage == nil && !messagesSent.isEmpty {
            for aMessage in messagesSent {
                if aMessage.id == messageId {
                    theMessage = aMessage
                    break;
                }
            }
        }
        if theMessage != nil {
            self.viewDelegate?.goToDetails(forMessage: theMessage!)
        } else {
            print("Message not found")
        }
    }
    
    // MARK: Internal
    private func getUniqueId(_ data: Data,_ string1: String,_ string2: String) -> String {
        return "ID:\(data)\(string1)\(string2)"
    }
    
    private func createSendingMessageFor(data: Data, type: MessageType) -> Message {
        let date = 02051987
        let uid = "1"
        let messageId = self.getUniqueId(data, String(date), uid)
        
        return Message(id: messageId, type: type, rawData: data, date: date, userId: uid, userName: "Franco Risma")
    }
    
    private func createReceivingMessageFor(data: Data, type: MessageType) -> Message {
        let date = 02051987
        let uid = "999"
        let messageId = self.getUniqueId(data, String(date), uid)
        
        return Message(id: messageId, type: type, rawData: data, date: date, userId: uid, userName: "The Bot")
    }
}
