//
//  File.swift
//  TestSocket
//
//  Created by lingda on 2018/9/30.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

import Foundation

enum ErrorCode : Int{
    case success = 0
    case systemError = 10000
    
    func description() -> String {
        switch self {
        case .success:
            return "成功"
        case .systemError:
            return "系统错误"
        default:
            break
        }
    }
}
