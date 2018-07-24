//
//  ITConversationPresenterProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

protocol ITConversationPresenterProtocol {
    
    func setViewDelegate(delegate: ITConversationViewControllerProtocol)
    func cameraButtonTapped()
    func sendMessage(text: String)
    func sendMessage(image: UIImage)
    func messageDetails(messageId: String)
}
