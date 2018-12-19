//
//  H5CtrCV.swift
//  Project
//
//  Created by lingda on 2018/11/15.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit
import WebKit

class H5CtrCV: UIViewController {
    var deviceObj : DeviceModel!
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self as WKScriptMessageHandler, name: "ling")
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        webView.backgroundColor = UIColor.white
        webView.uiDelegate = self as WKUIDelegate
        webView.navigationDelegate = self as WKNavigationDelegate
        webView.sizeThatFits(UIScreen.main.bounds.size)
        
        view.backgroundColor = UIColor.white
        LDHTTPTool.getDeviceCtrUrl(byDevice: deviceObj, inVC: self, taskDes: "请求URL", success: { (dataArr) in
            let model = dataArr?.first
            let url = URL.init(string: (model?.clickFunction)!)
            if let url = url {
                let request = URLRequest.init(url: url)
                self.view.addSubview(self.webView)
                self.webView.load(request)
            }
            
            
        }) { (errorDes) in
            MBProgressHUD.showTipMessage(inWindow: errorDes)
        }
    }

    
}


extension H5CtrCV:WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}




