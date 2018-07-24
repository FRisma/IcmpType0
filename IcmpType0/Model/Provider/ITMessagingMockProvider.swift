//
//  ITMessagingMockProvider.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class ITMessagingMockProvider: ITMessagingProviderProtocol {
    
    static let shared = ITMessagingMockProvider()
    
    private init() {
    }
    
    func send(message: Message, onCompletion: (NSError?) -> Void) {
        onCompletion(nil)
    }
    
    func getMessages(onCompletion: (Messages?, NSError?) -> Void) {
        guard let messages = try? JSONDecoder().decode(Messages.self, from: mockChats.data(using: .utf8)!) else {
            print("Error: Couldn't decode data into Chat")
            onCompletion(nil,NSError(domain:"com.icmpType0", code:500, userInfo:nil) )
            return
        }
        onCompletion(messages,nil)
    }
    
    func getChats(onCompletion: (Chats?, NSError?) -> Void) {
        guard let chats = try? JSONDecoder().decode(Chats.self, from: mockChats.data(using: .utf8)!) else {
            print("Error: Couldn't decode data into Chat")
            onCompletion(nil,NSError(domain:"com.icmpType0", code:500, userInfo:nil) )
            return
        }
        onCompletion(chats,nil)
    }
    
    let mockChats = """
                    {
                        "chat": [
                            {
                                "lastMessage": "Hola, que haces?",
                                "time": 12345677,
                                "member": "1",
                                "memberAlias": "Franco Risma"
                            },
                            {
                                "lastMessage": "Would you like to learn Swift?",
                                "time": 1234566,
                                "member": "1",
                                "memberAlias": "Rocio Gatica"
                            },
                            {
                                "lastMessage": "Te amo papá",
                                "time": 1234566,
                                "member": "1",
                                "memberAlias": "Emilia Risma"
                            },
                            {
                                "lastMessage": "Abrigate que está frío",
                                "time": 1234566,
                                "member": "1",
                                "memberAlias": "Marina Flores"
                            }
                        ]
                    }
                    """
    
    let mockMessages = """
                    {
                        "messages": [
                                {
                                    "message": "Hello",
                                    "name": "uid1",
                                    "timestamp": 1234566
                                },
                                {
                                    "message": "How are you?",
                                    "name": "uid2",
                                    "timestamp": 35435553535
                                }
                        ]
                    }
                    """
}
