//
//  ITMessagingServiceProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol ITMessagingServiceProtocol {
    
    func send(message: Message, onCompletion: @escaping(NSError?) -> Void)
    func getMessages(forConversation conversationId: String, onCompletion: @escaping([Message]?,NSError?) -> Void)
    func getChats(onCompletion: @escaping(Chats?, NSError?) -> Void)
}
