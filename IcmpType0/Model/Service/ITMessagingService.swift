//
//  ITMessagingService.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class ITMessagingService: ITMessagingServiceProtocol {
    
    private var provider: ITMessagingProviderProtocol!
    
    static let shared = ITMessagingService()
    
    private init() {
        provider = ITMessagingMockProvider.shared
    }
    
    init(provider: ITMessagingProviderProtocol) {
        self.provider = provider
    }
    
    func send(message: Message, onCompletion: @escaping (Bool) -> Void) {
        let wasSuccessful = self.randomBool()
        onCompletion(wasSuccessful)
    }
    
    func get(messages: [Message], onCompletion: @escaping (Bool) -> Void) {
        onCompletion(true)
    }
    
    private func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func getChats(onCompletion: @escaping (Chats) -> Void) {
        provider.getChats { (chats, error) in
            if error == nil {
                print("Service \(chats!)")
                onCompletion(chats!)
            } else {
                print("service error")
                //onCompletion(chats)
            }
        }
    }
}
