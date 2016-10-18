//
//  ViewController.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var webView: UIWebView!
    
    var targetUrl:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        let top = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        top.isActive = true
        webView.scalesPageToFit = true
        if (targetUrl != nil) {
            webView.loadRequest(URLRequest(url: targetUrl))
        }
        loadLocalFile("help", type: "html")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.openUrl(notifi:)), name: OpenNewStringFile, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func openUrl(notifi:Notification) {
        guard let url = notifi.object as? URL else {
            return 
        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseSourceLanguageTC") as? ChooseSourceLanguageTC {
            TranslateManager.sharedInstance().sourceURL = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = self.view.frame
    }
    
    func loadLocalFile(_ name:String,type:String){
        if let path = Bundle.main.path(forResource: name, ofType: type){
            targetUrl = URL(fileURLWithPath: path)
            if webView != nil {
                webView.loadRequest(URLRequest(url: targetUrl))
            }
        }
    }
    
    func loadWebURL(_ urlstr:String){
        targetUrl = URL(string: urlstr)
        if webView != nil {
            webView.loadRequest(URLRequest(url: targetUrl))
        }
    }

}

