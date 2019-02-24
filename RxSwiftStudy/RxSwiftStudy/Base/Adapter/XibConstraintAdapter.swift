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
    @IBInspectable var adjustConstraint: Bool {
        get { return true }
        set {
            if newValue {
                self.constant = self.constant * UIScreen.main.bounds.width / referenceSize
            }
        }
    }
}

