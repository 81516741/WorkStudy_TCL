//
//  LDBaseWebVC.swift
//  Project
//
//  Created by lingda on 2018/11/9.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class LDBaseWebVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.delegate = self
    }
    
    lazy var webView : UIWebView = {
       let webView = UIWebView(frame: UIScreen.main.bounds)
        return webView
    }()
}

//MARK:- webView的代理
extension LDBaseWebVC : UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}

//MARK:- 定义并实现h5的方法
extension LDBaseWebVC {
    
}
