//
//  Extension+Router.swift
//  RxSwiftStudy
//
//  Created by lingda on 2019/3/7.
//  Copyright © 2019年 lingda. All rights reserved.
//

extension UIResponder {
    @objc func routerEventWithType(eventType:String,userInfo:Any?) {
        next?.routerEventWithType(eventType: eventType, userInfo: userInfo)
    }
}
