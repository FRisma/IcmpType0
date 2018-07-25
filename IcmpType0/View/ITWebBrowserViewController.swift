//
//  ITWebBrowserViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 23/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import WebKit
import SnapKit

class ITWebBrowserViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView!
    private var url: URL
    
    //MARK: Initializers
    init(withURL url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    //MARK: Lifecycle
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
