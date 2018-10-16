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
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ld_titleColor = UIColor.white
        ld_naviBarColor = rgb(r: 110, g: 110, b: 123)
        title = "登录"
        LDSocketTool.startConnectAndHeart()
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        LDSocketTool.loging("13104475087", password: "123456", success: nil, failure: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        downKeyboard()
    }
    
    fileprivate func downKeyboard() {
        countTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
