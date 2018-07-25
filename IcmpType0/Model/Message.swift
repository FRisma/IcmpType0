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
    case text
    case image
    
    private enum CodingKeys: String, CodingKey {
        case text
        case image
    }
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
    //let date: Calendar
    let date: Int
    let userId: String
    let userName: String
    
    enum CodingKeys : String, CodingKey {
        case date = "timestamp"
        case userName = "name"
        case userId = "member"
        case rawData = "message"
        case type
    }
    
//    init(withString: Data, andType: MessageType ) {
//        type = andType
//        rawData = withString
//        date = Calendar.current
//        fakeDate = 12345
//        sender = "Franco Risma"
//    }
//
//    init(withString: Data, type: MessageType, date: Calendar, andSender: String) {
//        rawData = withString
//        self.type = type
//        self.date = date
//        fakeDate = 12345
//        sender = andSender
//    }
    
//    func set(data: Any, forType type: MessageType) {
//        switch type {
//        case .text:
//            let text = data as? String ?? ""
//            rawData = text.data(using: .utf8)!
//        case .image:
//            print("Imagen")
//            //rawData = UIImagePNGRepresentation(data)
//        }
//    }
}
