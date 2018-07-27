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
    let spinnerView = ITLoadingIndicatorView.shared
    
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
        
        self.showLoadingIndicator()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: WKNavigationDelegate
    internal func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling,nil)
    }
    
    /*
     * While loading the web view, we evaluate for response's error status codes
     */
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    /*
     * WebView starts receiving content
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.hideLoadingIndicator()
    }
    
    /*
     * The URL to load is valid, but there webServer is not responding
     */
    internal func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Server unreachable. loadRequest: failed with error:\(error)")
        self.handleWebViewError(error)
    }
    
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Server unreachable. loadRequest: failed with error:\(error)")
        self.handleWebViewError(error)
    }

    //MARK: Internal
    private func showLoadingIndicator() {
        self.view.addSubview(spinnerView)
    }
    
    private func hideLoadingIndicator() {
        spinnerView.removeFromSuperview()
    }
    
    private func handleWebViewError(_ error: Error) {
        self.hideLoadingIndicator()
        let alert = UIAlertController(title: "Error", message: "Web could not be loaded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}
