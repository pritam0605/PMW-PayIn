//
//  WebViewController.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 01/10/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var urlToOpen:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if   let url = URL(string: urlToOpen) {
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonClickBack(_ sender: UIButton) {
        self.navigateToPreviousPage()
    }
    
    func navigateToPreviousPage() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashboardViewController.self) {
                _ =  self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }

    
}
