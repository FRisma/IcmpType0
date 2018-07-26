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
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.dateDecodingStrategy = .iso8601
        decoder.dataDecodingStrategy = .base64
    }
    
    func send(message: Message, onCompletion: (NSError?) -> Void) {
        onCompletion(nil)
        
        //Reply back by sending a new message and posting a notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let newReplyMessage = self.createReceivingMessageFor(data: message.rawData, type: message.type)
            NotificationCenter.default.post(name: .kITNotificationMessageReceived, object: ITMessagingMockProvider.shared, userInfo: ["data": newReplyMessage])
        })
    }
    
    func getMessages(onCompletion: (Messages?, NSError?) -> Void) {
        guard let messages = try? decoder.decode(Messages.self, from: mockMessages.data(using: .utf8)!) else {
            print("Error: Couldn't decode data into Messages")
            onCompletion(nil,NSError(domain:"com.icmpType0", code:500, userInfo:nil) )
            return
        }
        onCompletion(messages,nil)
    }
    
    func getChats(onCompletion: (Chats?, NSError?) -> Void) {
        guard let chats = try? decoder.decode(Chats.self, from: mockChats.data(using: .utf8)!) else {
            print("Error: Couldn't decode data into Chat")
            onCompletion(nil,NSError(domain:"com.icmpType0", code:500, userInfo:nil) )
            return
        }
        onCompletion(chats,nil)
    }
    
    // MARK: Internal
    private func createReceivingMessageFor(data: Data, type: MessageType) -> Message {
        return Message(type: type, rawData: data, date: Date(), userId: "999", userName: "The Bot")
    }
    
    let mockChats = """
                    {
                        "chat": [
                            {
                                "lastMessage": "Para un argentino no hay nada mejor que otro argentino",
                                "time": "2018-05-19T16:39:57-22:00",
                                "member": "8",
                                "memberAlias": "Pedro Risma"
                            },
                            {
                                "lastMessage": "Would you like to learn Swift?",
                                "time": "2018-07-19T08:39:57-20:00",
                                "member": "2",
                                "memberAlias": "Rocio Gatica"
                            },
                            {
                                "lastMessage": "Te amo papá, feliz cumple",
                                "time": "2018-05-02T04:00:57-00:00",
                                "member": "3",
                                "memberAlias": "Emilia Risma"
                            },
                            {
                                "lastMessage": "Abrigate que está frío",
                                "time": "2018-12-19T16:39:57-08:00",
                                "member": "4",
                                "memberAlias": "Marina Flores"
                            },
                            {
                                "lastMessage": "Ya compre las pelotas para el metegol",
                                "time": "2018-12-19T16:39:57-08:00",
                                "member": "5",
                                "memberAlias": "Elias Medina"
                            },
                            {
                                "lastMessage": "Feliz día",
                                "time": "2018-12-19T16:39:57-08:00",
                                "member": "6",
                                "memberAlias": "Juanma Rodriguez"
                            },
                            {
                                "lastMessage": "7 - 0 les ganamos, nos deben una coca",
                                "time": "2018-12-19T16:39:57-08:00",
                                "member": "7",
                                "memberAlias": "Carlos Albornoz"
                            },
                            {
                                "lastMessage": "Hola, que haces?",
                                "time": "2018-12-19T16:39:57-08:00",
                                "member": "1",
                                "memberAlias": "Franco Risma"
                            }
                            
                        ]
                    }
                    """
    
    let mockMessages = """
                    {
                        "messages": [
                                {
                                    "message": "SG9sYSBjb21vIGFuZGFzPw0K",
                                    "type": "text",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "time": "2018-12-19T16:39:57-08:00"
                                },
                                {
                                    "message": "TXV5IGJpZW4geSB2b3M/DQo=",
                                    "type": "text",
                                    "name": "Best Friend",
                                    "member": "999",
                                    "time": "2018-12-19T16:39:57-08:00"
                                },
                                {
                                    "message": "WWEgdmlzdGUgbGEgcGFnaW5hIGh0dHA6Ly9pbnRpdmUtZmR2LmNvbS5hciA/",
                                    "type": "text",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "time": "2018-12-19T16:39:57-08:00"
                                },
                                {
                                    "message": "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",
                                    "type": "image",
                                    "name": "Best Friend",
                                    "member": "1",
                                    "time": "2018-12-20T16:39:57-08:00"
                                }
                        ]
                    }
                    """
}
