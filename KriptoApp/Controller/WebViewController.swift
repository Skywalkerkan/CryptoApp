//
//  WebViewController.swift
//  KriptoApp
//
//  Created by Erkan on 5.05.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!

    var url = ""
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: url)
             let myRequest = URLRequest(url: myURL!)
             webView.load(myRequest)

    }
    


}
