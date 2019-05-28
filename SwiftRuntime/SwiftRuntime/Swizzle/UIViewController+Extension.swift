//
//  UIViewController+Extension.swift
//  SwiftRuntime
//
//  Created by lingda on 2019/5/28.
//  Copyright © 2019年 lingda. All rights reserved.
//

import UIKit
extension ViewController: SwizzleProtocol {
    static func swizzle() {
        swizzle(origin: #selector(viewDidLoad), des: #selector(ld_viewDidLoad))
    }
    @objc func ld_viewDidLoad() {
        ld_viewDidLoad()
        print("替换了")
    }
}
