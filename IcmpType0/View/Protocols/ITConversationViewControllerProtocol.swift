//
//  ITConversationViewControllerProtocol.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation

protocol ITConversationViewControllerProtocol {

    func messageSent(message: String)
    func messageReceived(message: String)
    func showError(info: String?)
    func goToDetails()
}
