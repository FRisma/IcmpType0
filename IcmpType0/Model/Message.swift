//
//  Message.swift
//  IcmpType0
//
//  Created by Franco Risma on 22/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

enum MessageType: String, Codable{
    case text, image
}

struct Messages: Decodable {
    let conversations: [Message]
    
    enum CodingKeys : String, CodingKey {
        case conversations = "messages"
    }
}

struct Message: Decodable {
    let type: MessageType
    var rawData: Data
    let date: Date
    let userId: String
    let userName: String
    
    enum CodingKeys : String, CodingKey {
        case date = "time"
        case userName = "name"
        case userId = "member"
        case rawData = "message"
        case type
    }
}
