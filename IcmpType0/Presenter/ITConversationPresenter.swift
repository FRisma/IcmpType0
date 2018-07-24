//
//  ITConversationPresenter.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class ITConversationPresenter: ITConversationPresenterProtocol {
    
    private var viewDelegate: ITConversationViewControllerProtocol?
    private var service = ITMessagingService.shared
    
    // MARK: ITConversationPresenterProtocol
    func setViewDelegate(delegate: ITConversationViewControllerProtocol) {
        viewDelegate = delegate
    }
    
    func cameraButtonTapped() {
        
    }
    
    func sendMessage(text: String) {
        let aMessage = Message(withString: text.data(using: String.Encoding.utf8)!, andType: .text)
        self.service.send(message: aMessage) { (success) in
            if success {
                self.viewDelegate?.messageSent(message: text)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.viewDelegate?.messageReceived(message: text)
                })
            } else {
                self.viewDelegate?.showError(info: "Message could not be sent, please try again")
            }
        }
        
        /*
        if let messageTxt = String(data: message.rawData, encoding: String.Encoding.utf8) {
            self.addMessage(text: messageTxt, color: .yellow, backgroundColor: .blue)
        }*/
        
        /*
         if let messageTxt = String(data: message.rawData, encoding: String.Encoding.utf8) {
         self.addMessage(text: messageTxt, color: .blue, backgroundColor: .yellow)
         }*/
    }
    
    func sendMessage(image: UIImage) {
        
    }
    
    func messageDetails() {
        
    }
}
