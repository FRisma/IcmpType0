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
                                "member": "2",
                                "memberAlias": "Rocio Gatica"
                            },
                            {
                                "lastMessage": "Te amo papá",
                                "time": 1234566,
                                "member": "3",
                                "memberAlias": "Emilia Risma"
                            },
                            {
                                "lastMessage": "Abrigate que está frío",
                                "time": 1234566,
                                "member": "4",
                                "memberAlias": "Marina Flores"
                            },
                            {
                                "lastMessage": "Ya compre las pelotas para el metegol",
                                "time": 1827364872,
                                "member": "5",
                                "memberAlias": "Elias Medina"
                            },
                            {
                                "lastMessage": "Feliz día",
                                "time": 1234566,
                                "member": "6",
                                "memberAlias": "Juan Rodriguez"
                            },
                            {
                                "lastMessage": "7 - 0 le ganamos, nos deben una coca",
                                "time": 1234566,
                                "member": "7",
                                "memberAlias": "Carlos Albornoz"
                            },
                            {
                                "lastMessage": "Sumate y multiplica 2x1",
                                "time": 1234566,
                                "member": "8",
                                "memberAlias": "Movistar"
                            }
                        ]
                    }
                    """
    
    let mockMessages = """
                    {
                        "messages": [
                                {
                                    "id": "123"
                                    "message": "Hello",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "timestamp": 1234566
                                },
                                {
                                    "id": "124"
                                    "message": "How are you?",
                                    "name": "Bot",
                                    "member": "999",
                                    "timestamp": 354355535
                                },
                                {
                                    "id": "125"
                                    "message": "Fine thanks",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "timestamp": 123456342
                                }
                        ]
                    }
                    """
}
