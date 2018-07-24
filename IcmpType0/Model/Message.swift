//
//  Message.swift
//  IcmpType0
//
//  Created by Franco Risma on 22/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

enum MessageType :String{
    case text
    case image
}

class Message {
    var type: MessageType
    var rawData: Data
    var date: Calendar
    var sender: String
    
    init(withString: Data, andType: MessageType ) {
        type = andType
        rawData = withString
        date = Calendar.current
        sender = "Franco Risma"
    }
    
    init(withString: Data, type: MessageType, date: Calendar, andSender: String) {
        rawData = withString
        self.type = type
        self.date = date
        sender = andSender
    }
    
    func set(data: Any, forType type: MessageType) {
        switch type {
        case .text:
            let text = data as? String ?? ""
            rawData = text.data(using: .utf8)!
        case .image:
            print("Imagen")
            //rawData = UIImagePNGRepresentation(data)
        }
    }
}
