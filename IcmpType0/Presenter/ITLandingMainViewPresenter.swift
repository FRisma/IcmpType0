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
    
    // MARK: ITLandingMainViewPresenterProtocol
    func setViewDelegate(delegate: ITLandingMainViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func fetchConversations() {
        viewDelegate?.updateConversations()
    }
    
    func conversationTapped() {
    
    }
    
    func composeButtonTapped() {
        
    }
    
}
