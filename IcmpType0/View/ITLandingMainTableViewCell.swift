//
//  ITLandingMainTableViewCell.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ITLandingMainTableViewCell: UITableViewCell {
    
    var profileName = UILabel()
    var messageLabel = UILabel()
    var dateLabel = UILabel()
    var profileImage = UIImageView(frame: .zero)
    
    private let containerView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileName = UILabel(frame: .zero)
        profileName.numberOfLines = 1
        profileName.font = .boldSystemFont(ofSize: 18)
        
        messageLabel = UILabel(frame: .zero)
        messageLabel.numberOfLines = 1
        messageLabel.font = .systemFont(ofSize: 15)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.numberOfLines = 1
        dateLabel.font = .systemFont(ofSize: 12)
        
        profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 30
        
        containerView.addSubview(profileName)
        containerView.addSubview(messageLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(profileImage)
        self.addSubview(containerView)
        
        self.applyConstraints()
    }
    
    private func applyConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.containerView)
            make.top.equalTo(self.containerView).offset(20)
            make.left.equalTo(self.containerView).offset(20)
            make.bottom.lessThanOrEqualTo(self.containerView).offset(20)
            make.right.lessThanOrEqualTo(self.profileName.snp.left)
            make.size.equalTo(60)
        }
        
        profileName.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage).offset(2)
            make.left.equalTo(self.profileImage.snp.right).offset(10)
            make.right.equalTo(self.containerView).offset(-10)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileName.snp.bottom).offset(15)
            make.left.equalTo(profileName)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileName)
            make.right.equalTo(self.containerView).offset(-10)
        }
    }
}
