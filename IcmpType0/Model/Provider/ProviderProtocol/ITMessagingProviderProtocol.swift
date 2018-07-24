//
//  ITMessagingProviderProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol ITMessagingProviderProtocol {
    
    func send(message: Message, onCompletion:(NSError?) -> Void)
    func get(messages: [Message], onCompletion:(Message, NSError?) -> Void)
    func getChats(onCompletion:(Chats?, NSError?) -> Void)
}
