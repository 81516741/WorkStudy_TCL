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

class SocketManager: NSObject {
    static let `default` = SocketManager()
    static let messageSubject = PublishSubject<String>()
    static let connectSubject = PublishSubject<Bool>()
    let socketQueue = DispatchQueue(label: "网络请求的队列")
    let timeOut = 30
    var socket:GCDAsyncSocket!
    var host:String = ""
    var port:String = ""
    
    func connect(toHost host:String?,toPort port:String?) {
        guard let host0 = host else {
            print("host为nil")
            return
        }
        guard let port0 = port else {
            print("port为nil")
            return
        }
        guard let portUInt16 = UInt16(port0)else {
            print("port:" + port0 + "不是UInt16格式")
            return
        }
        self.host = host0
        self.port = port0
        if socket == nil {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: socketQueue)
        }
        do {
            try socket.connect(toHost: host0, onPort: portUInt16, withTimeout: TimeInterval(timeOut))
        } catch {
            print("socket连接出错")
        }
    }
    
    func send(message msg:String?) {
        guard let msg0 = msg else {
            print("发给服务器的消息为nil")
            return
        }
        if let data = msg0.data(using: .utf8) {
            print("发送消息：\(msg0)")
            socket.write(data, withTimeout: TimeInterval(timeOut), tag: 0)
        } else {
            print(msg0 + "无法转成data")
        }
    }
}

extension SocketManager : GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("socket连接成功")
        SocketManager.connectSubject.onNext(true)
        sock.readData(withTimeout: TimeInterval(timeOut), tag: 0)
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket断开连接")
        SocketManager.connectSubject.onNext(false)
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: TimeInterval(timeOut), tag: tag)
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let dataString = String(data: data, encoding: .utf8) {
            print("收到数据：\(dataString)")
            SocketManager.messageSubject.onNext(dataString)
            sock.readData(withTimeout: TimeInterval(timeOut), tag: tag)
        }
    }
}
