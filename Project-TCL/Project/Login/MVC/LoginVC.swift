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
        let item = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(dismissSelf))
        item.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = item
    }
    
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        LDSocketTool.loging(countTextField.text, password: passwordTextField.text, success: { (data) in
            self.ld_loginSuccessBlock(data,self)
        }) { (error) in
            print(error as! String)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        downKeyboard()
    }
    
    fileprivate func downKeyboard() {
        countTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
