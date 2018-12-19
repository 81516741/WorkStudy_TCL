//
//  NetCheckTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

enum NetState {
    case noNet
    case hasNet
}
class NetCheckTool {
    static let netState : BehaviorRelay<NetState> = BehaviorRelay(value: .noNet)
    static let manager = NetworkReachabilityManager(host: "www.baidu.com")
    class func checkNet() {
        manager?.listener = { status in
            switch status {
            case .unknown,.notReachable:
                netState.accept(.noNet)
                break
            case .reachable:
                netState.accept(.hasNet)
                break
            }
        }
        manager?.startListening()
    }
}
