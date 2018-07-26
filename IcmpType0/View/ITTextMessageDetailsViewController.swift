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

class ITTextMessageDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var aMessage: Message!
    private let textMessageLabel = UILabel()
    private let senderTitleLabel = UILabel()
    private let senderLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private var linksTableView : UITableView!
    private var detecetdURLs = [URL]()
    
    init(withMessage message: Message) {
        super.init(nibName: nil, bundle: nil)
        let displayText = String(data: message.rawData, encoding: String.Encoding.utf8)
        textMessageLabel.text = displayText
        senderLabel.text = message.userName
        detecetdURLs = ITStringAnalyzer.urlArrayIn(string: displayText ?? "")
        senderTitleLabel.text = "Remitente"
        dateTitleLabel.text = "Fecha"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        dateLabel.text = dateFormatter.string(from: message.date)
        
        view.backgroundColor = .clear
        let backgroundLayer = GradientColors(withTopColor: UIColor(0x8fba92), bottomColor: UIColor(0xbef7c2)).layer
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        senderTitleLabel.textAlignment  = .left
        senderLabel.textAlignment       = .left
        dateTitleLabel.textAlignment    = .left
        dateLabel.textAlignment         = .left
        
        textMessageLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        textMessageLabel.textAlignment = .center
        textMessageLabel.numberOfLines = 0
        textMessageLabel.lineBreakMode = .byWordWrapping
        
        view.addSubview(senderTitleLabel)
        view.addSubview(senderLabel)
        view.addSubview(dateTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(textMessageLabel)
        
        if !detecetdURLs.isEmpty {
            linksTableView = UITableView()
            linksTableView.delegate = self
            linksTableView.dataSource = self
            linksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "links")
            linksTableView.tableFooterView = UIView()
            linksTableView.backgroundColor = .clear
            view.addSubview(linksTableView)
        }
        
        self.applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.applyConstraints()
    }
    
    //MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detecetdURLs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "links")
        cell?.textLabel?.text = detecetdURLs[indexPath.row].absoluteString
        cell?.textLabel?.textAlignment = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isIndexValid = detecetdURLs.indices.contains(indexPath.row)
        if isIndexValid {
            let browserVC = ITWebBrowserViewController(withURL: detecetdURLs[indexPath.row])
            self.navigationController?.pushViewController(browserVC, animated: true)
        }
    }
    
    //MARK: Internal
    private func applyConstraints() {
        senderTitleLabel.snp.remakeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(self.view)
            }
            make.right.equalTo(view.snp.left) // Out of bounds so it can be animated
        }
        
        senderLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(senderTitleLabel)
            make.left.equalTo(view.snp.right) // Out of bounds so it can be animated
        }
        
        dateTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(senderTitleLabel.snp.bottom).offset(20)
            make.right.equalTo(view.snp.left) // Out of bounds so it can be animated
        }
        
        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(dateTitleLabel)
            make.left.equalTo(view.snp.right) // Out of bounds so it can be animated
        }
        
        textMessageLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view)
        }
        
        if linksTableView != nil {
            linksTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(textMessageLabel.snp.bottom).offset(20)
                make.left.right.bottom.equalTo(view)
            }
        }
    }
    
    private func startAnimating() {
        UIView.animate(withDuration: 0.5, animations: {
            self.senderTitleLabel.snp.remakeConstraints { (make) in
                if #available(iOS 11, *) {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
                } else {
                    make.top.equalTo(self.view)
                }
                make.right.equalTo(self.view).multipliedBy(0.48)
            }
            self.senderTitleLabel.superview?.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            self.senderLabel.snp.remakeConstraints { (remake) in
                remake.top.equalTo(self.senderTitleLabel)
                remake.left.equalTo(self.view.snp.centerX)
            }
            self.senderLabel.superview?.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            self.dateTitleLabel.snp.remakeConstraints { (remake) in
                remake.top.equalTo(self.senderTitleLabel.snp.bottom).offset(20)
                remake.right.equalTo(self.view).multipliedBy(0.48)
            }
            self.dateTitleLabel.superview?.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            self.dateLabel.snp.remakeConstraints { (remake) in
                remake.top.equalTo(self.dateTitleLabel)
                remake.left.equalTo(self.view.snp.centerX)
            }
            self.dateLabel.superview?.layoutIfNeeded()
        }, completion: { (finished) in
            self.view.shake(view: self.textMessageLabel)
        })   
    }
}
