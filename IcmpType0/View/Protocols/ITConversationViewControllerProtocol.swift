//
//  ITConversationViewControllerProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

protocol ITConversationViewControllerProtocol {

    func messageSent(message: String)
    func messageReceived(message: String)
    func messageSent(message: UIImage)
    func messageReceived(message: UIImage)
    func showError(info: String?)
    func goToDetails(forMessage message: Message)
}
