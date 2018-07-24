//
//  ITMessageDetailsViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ITTextMessageDetailsViewController: UIViewController {
    
    var aMessage: Message!
    private var textMessageLabel = UILabel()
    private var senderTitleLabel = UILabel()
    private var senderLabel = UILabel()
    private var dateTitleLabel = UILabel()
    private var dateLabel = UILabel()
    
    init(withMessage message: Message) {
        super.init(nibName: nil, bundle: nil)
        textMessageLabel.text = String(data: message.rawData, encoding: String.Encoding.utf8) as! String
        senderLabel.text = message.sender
        dateLabel.text = "02/05/1987"
        senderTitleLabel.text = "Remitente"
        dateTitleLabel.text = "Fecha"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(senderTitleLabel)
        view.addSubview(senderLabel)
        view.addSubview(dateTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(textMessageLabel)
        
        self.applyConstraints()
    }
    
    //MARK: Internal
    private func applyConstraints() {
        senderTitleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalTo(view).multipliedBy(0.5)
        }
        
        senderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(senderTitleLabel)
            make.left.equalTo(senderTitleLabel.snp.right)
        }
        
        dateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(senderTitleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(senderTitleLabel)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateTitleLabel)
            make.left.equalTo(dateTitleLabel.snp.right)
        }
        
        textMessageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view)
        }
    }
}
