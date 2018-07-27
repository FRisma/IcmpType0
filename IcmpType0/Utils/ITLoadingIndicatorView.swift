//
//  ITLoadingIndicatorView.swift
//  IcmpType0
//
//  Created by Franco Risma on 27/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit

class ITLoadingIndicatorView: UIView {
    
    static let shared = ITLoadingIndicatorView()
    
    let loadingIndicator: UIActivityIndicatorView!
    
    override private init(frame: CGRect) {
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        let middlePoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5)
        loadingIndicator.center = middlePoint
        loadingIndicator.hidesWhenStopped = true;
        
        self.addSubview(loadingIndicator)
        self.bringSubview(toFront: loadingIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func didMoveToSuperview() {
        if (self.superview != nil) {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
