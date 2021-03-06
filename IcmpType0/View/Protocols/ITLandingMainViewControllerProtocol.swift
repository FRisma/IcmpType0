//
//  ITLandingMainViewControllerProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol ITLandingMainViewControllerProtocol {
    
    func updateConversations(chats: Chats)
    func goToConversation()
    func createNewConversation()
    func showError(info: String?)
}
