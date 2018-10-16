//
//  LoginVC.swift
//  Project
//
//  Created by lingda on 2018/10/15.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class LoginVC: UIViewController  {
    @IBOutlet weak var topCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        ld_titleColor = UIColor.white
        ld_naviBarColor = rgb(r: 110, g: 110, b: 123)
        title = "登录"
        LDSocketTool.buildConnectingSuccess(nil, failure: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
