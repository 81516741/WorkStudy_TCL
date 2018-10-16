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
    }

    @IBAction func jump(_ sender: Any) {
        LDFunctionTool.gotoFunction(by: .otherVC, inVC: self)
    }
}
