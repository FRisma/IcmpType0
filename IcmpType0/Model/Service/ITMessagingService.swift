//
//  ITMessagingService.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class ITMessagingService: ITMessagingServiceProtocol {
    
    private var provider: ITMessagingProviderProtocol!
    
    static let shared = ITMessagingService()
    
    private init() {
        provider = ITMessagingMockProvider.shared
    }
    
    init(provider: ITMessagingProviderProtocol) {
        self.provider = provider
    }
    
    func send(message: Message, onCompletion: @escaping (NSError?) -> Void) {
        provider.send(message: message) { (error) in
            if error != nil {
                // Generate an error
                return onCompletion(error)
            }
            return onCompletion(nil)
        }
    }
    
    func get(messages: [Message], forConversation conversationId: String, onCompletion: @escaping ([Message]?,NSError?) -> Void) {
        provider.getMessages { (messages, error) in
            if error != nil {
                return onCompletion(nil,error)
            }
            return onCompletion(messages?.conversations,nil)
        }
    }
    
    func getChats(onCompletion: @escaping (Chats?, NSError?) -> Void) {
        provider.getChats { (chats, error) in
            if error == nil {
                print("Service \(chats!)")
                onCompletion(chats!,nil)
            } else {
                print("service error")
                onCompletion(nil,NSError(domain: "com.IcmpType0", code: 123, userInfo: nil))
            }
        }
    }
}
