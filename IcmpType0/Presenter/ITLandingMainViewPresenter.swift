//
//  ITLandingMainViewPresenter.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

class ITLandingMainViewPresenter: ITLandingMainViewPresenterProtocol {

    private var viewDelegate: ITLandingMainViewControllerProtocol?
    private var service = ITMessagingService.shared
    
    // MARK: ITLandingMainViewPresenterProtocol
    func setViewDelegate(delegate: ITLandingMainViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func fetchConversations() {
        self.service.getChats { (chats, error) in
            if let chats = chats, !chats.conversations.isEmpty && error == nil {
                self.viewDelegate?.updateConversations(chats: chats)
            } else {
                self.viewDelegate?.showError(info: "Could not load your conversations")
            }
        }
    }
    
    func conversationTapped() {
        self.viewDelegate?.goToConversation()
    }
    
    func composeButtonTapped() {
        self.viewDelegate?.createNewConversation()
    }
    
}
