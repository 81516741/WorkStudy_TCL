//
//  Target_Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit

class Target_Mine: NSObject {
    @objc func Action_nativeFetchMineVC(params:NSDictionary) -> UIViewController{
        print(params)
        return ViewController()
    }
    @objc func noMethod(params:NSDictionary)  {
        print("没有找到对应方法")
    }
}


