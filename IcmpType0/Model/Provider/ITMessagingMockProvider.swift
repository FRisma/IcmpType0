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
                                    "message": "Hello",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "time": "2018-12-19T16:39:57-08:00"
                                },
                                {
                                    "message": "How are you?",
                                    "name": "Bot",
                                    "member": "999",
                                    "time": "2018-12-19T16:39:57-08:00"
                                },
                                {
                                    "message": "Fine thanks",
                                    "name": "Franco Risma",
                                    "member": "1",
                                    "time": "2018-12-19T16:39:57-08:00"
                                }
                        ]
                    }
                    """
}
