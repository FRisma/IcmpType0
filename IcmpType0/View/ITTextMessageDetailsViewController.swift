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
        let displayText = String(data: message.rawData, encoding: String.Encoding.utf8) as! String
        textMessageLabel.text = displayText
        senderLabel.text = message.userName
        detecetdURLs = ITStringAnalyzer.urlArrayIn(string: displayText)
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
            let headerView = UILabel()
            headerView.textAlignment = .left
            headerView.text = "Links encontrados"
            headerView.numberOfLines = 1
            headerView.backgroundColor = .red
            linksTableView.tableHeaderView = headerView
            view.addSubview(linksTableView)
        }
        
        self.applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var newFrame = senderTitleLabel.frame
        newFrame.origin.x = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.senderTitleLabel.frame = newFrame
        }, completion: nil)
        
        var newFrame2 = senderLabel.frame
        newFrame2.origin.x = 113
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.senderLabel.frame = newFrame2
        }, completion: nil)
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
        senderTitleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalTo(self.view)
            }
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
        
        if linksTableView != nil {
            linksTableView.snp.makeConstraints { (make) in
                make.top.equalTo(textMessageLabel.snp.bottom).offset(20)
                make.left.right.bottom.equalTo(view)
            }
        }
    }
}
