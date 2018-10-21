//
//  LDHomeVC.swift
//  Project
//
//  Created by lingda on 2018/10/16.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class LDHomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ld_naviBarColor = UIColor.orange
        NotificationCenter.default.addObserver(self, selector: #selector(autoLoginFailure), name: NSNotification.Name.autoLoginFailure, object: nil)
    }

    @objc func autoLoginFailure() {
        LDConfigVCUtil.configLoginVC(toRootVC: true)
    }
    
    @IBAction func jump(_ sender: Any) {
       navigationController?.pushViewController(LDOtherVC(), animated: true)
    }
    @IBAction func getDeviceList(_ sender: Any) {
        LDSocketTool.getDeviceListSuccess(nil, failure: nil)
    }
    @IBAction func getSceneList(_ sender: Any) {
        LDSocketTool.getSceneListSuccess(nil, failure: nil)
    }
}
