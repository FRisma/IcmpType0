//
//  ITMessagingServiceProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol ITMessagingServiceProtocol {
    
    func send(message: Message, onCompletion: @escaping(Bool) -> Void)
    func get(messages: [Message], onCompletion: @escaping(Bool) -> Void)
    func getChats(onCompletion: @escaping(Chats) -> Void)
}
