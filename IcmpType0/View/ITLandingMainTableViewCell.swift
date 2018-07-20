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
    
    var profilePictureURL: String? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var profileName = UILabel()
    private var profileImage = UIImageView(frame: .zero)
    
    private let containerView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileName = UILabel(frame: .zero)
        profileName.numberOfLines = 1
        profileName.font = .systemFont(ofSize: 22)
        
        profileImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        
        containerView.addSubview(profileImage)
        containerView.addSubview(profileImage)
        self.addSubview(containerView)
        
        self.applyConstraints()
    }
    
    private func applyConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        profileName.snp.makeConstraints { (make) in
            make.top.equalTo(self.containerView)
            make.left.equalTo(self.containerView)
        }
    }
    
    
}
