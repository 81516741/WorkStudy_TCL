//
//  LoginTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class SocketLoginTool: NSObject {
    static let loginSubject = PublishSubject<Bool>()
    class func autoLogin() {
        Log("发起自动登录")
        //从数据库取出相关信息
        //判断是否可以自动登录
    }
    class func login(result:@escaping (String)->()) {
        SocketTool.send(message: "", result: result)
    }
    class func receive(_ message:String) {
        SocketTool.callBack("我是消息")
    }
}
