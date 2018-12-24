//
//  SocketManager.swift
//  SwiftData
//
//  Created by lingda on 2018/12/17.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import RxSwift
import RxCocoa

enum ConnectState {
    case none
    case connected
    case disConnect
}

class SocketManager: NSObject {
    static let `default` = SocketManager()
    let messageSubject = PublishSubject<String>()
    let connectRelay = BehaviorRelay<ConnectState>(value: .none)
    var socket:Socket!
    var host:String = ""
    var port:String = ""
    
    func connect(toHost host:String?,toPort port:String?) {
        guard let host0 = host else {
            Log("host为nil")
            return
        }
        guard let port0 = port else {
            Log("port为nil")
            return
        }
        guard let portUInt16 = UInt16(port0)else {
            Log("port:" + port0 + "不是UInt16格式")
            return
        }
        self.host = host0
        self.port = port0
        if socket == nil {
            socket = Socket()
            socket.connectResult = {
                if $0 {
                    self.connectRelay.accept(.connected)
                } else {
                    self.connectRelay.accept(.disConnect)
                }
            }
            socket.msgResult = {
                if let msg = $0 {
                  Log("收到消息:\(msg)")
                    self.messageSubject.onNext(msg)
                }
            }
        }
        socket.connect(host, toPort: portUInt16)
    }
    
    func send(message msg:String?) {
        if connectRelay.value != .connected {
            Log("socket没有连接服务器")
            return
        }
        guard let msg0 = msg else {
            Log("发给服务器的消息为nil")
            return
        }
        if let data = msg0.data(using: .utf8) {
            Log("发送消息：\(msg0)")
            socket.send(data)
        } else {
            Log(msg0 + "无法转成data")
        }
    }
    func startTLS() {
        Log("开启TLS")
        socket.startTSL()
    }
}
