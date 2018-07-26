//
//  Chat.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

struct Chats: Decodable {
    let conversations: [Chat]
    
    enum CodingKeys : String, CodingKey {
        case conversations = "chat"
    }
}

struct Chat: Decodable {
    let lastMessage: String!
    let date: Date
    let member: String
    let memberName: String
    
    enum CodingKeys : String, CodingKey {
        case lastMessage
        case date = "time"
        case member
        case memberName = "memberAlias"
    }
}
