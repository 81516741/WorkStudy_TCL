//
//  XibConstraintAdapter.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let referenceSize : CGFloat = 375.0
extension NSLayoutConstraint {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if identifier == "666" {return}
        self.constant = self.constant * UIScreen.main.bounds.width / referenceSize
    }
    //保留 万一上面的方法出了问题有个参照
//    @IBInspectable var adjustSize: Bool {
//        get { return true }
//        set {
//            if newValue {
//                self.constant = self.constant * UIScreen.main.bounds.width / referenceSize
//            }
//        }
//    }
}

