//
//  ITImageDetailsViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 25/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import UIKit

class ITImageDetailsViewController: UIViewController {
    
    private var anImage: UIImage!
    private let scrollView = UIScrollView(frame: .zero)
    
    init(withMessage message: Message) {
        anImage = UIImage(data: message.rawData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let imageView = UIImageView(image: anImage)
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
