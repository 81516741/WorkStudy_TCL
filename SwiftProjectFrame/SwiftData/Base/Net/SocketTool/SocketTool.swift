//
//  SocketTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum OpenStreamStep {
    case none
    case fristStream
    case startTLS
    case secondStream
    case ok
}
typealias resultBlock = (Any)->()
class SocketTool: NSObject {
    
    static var timer:DispatchSourceTimer?
    static let openStreamBehavior = BehaviorRelay<OpenStreamStep>(value: .none)
    static var blocks = [[String:Array<resultBlock>]]()
    
    class func send(_ msg:String,_ success:@escaping resultBlock,_ failure:@escaping resultBlock) {
        if openStreamBehavior.value == .none {
            failure("当前网络未连接")
            return
        }
        addBlock(msg,[failure,success])
    }
    class func buildConnect(toHost:String?,toPort:String?) {
        SocketManager.default.connect(toHost: toHost, toPort: toPort)
    }
    class func prepareSocket() {
        listenMessage()
        listenStreamMsg()
        listenOpenStream()
    }
    fileprivate class func listenMessage() {
        let _ = SocketManager.default.messageSubject.bind(to: msgHandle())
    }
    fileprivate class func msgHandle() -> AnyObserver<String> {
        return AnyObserver { event in
            if let msg = event.element {
                if msg.contains("login_module") {
                    
                } else if msg.contains("A_module") {
                    
                } else if msg.contains("B_module") {
                    
                } else if msg.contains("C_module") {
                    
                } else if msg.contains("D_module") {
                    
                }
                SocketLoginTool.receive(msg)
            }
        }
    }
    fileprivate class func addBlock(_ message:String,_ blocks:Array<resultBlock>) {
        let msgID = "消息ID"
        self.blocks.append([msgID:blocks])
        if blocks.count > 100 {
            self.blocks.removeFirst()
        }
    }
    class func resultCallBack(_ msg:Any?,_ msgID:String?,_ err:String? = nil) {
        let msgID = msgID ?? "消息ID"
        for value in blocks {
            if let key = value.keys.first {
                if key == msgID {
                    DispatchQueue.main.async {
                        if let err = err {
                            value.values.first?.first?(err)
                        } else {
                            if let msg = msg {
                               value.values.first?.last?(msg)
                            } else {
                               value.values.first?.first?("赞无数据")
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: 开流的
extension SocketTool {
    class func openStream() {
        openStreamBehavior.accept(.fristStream)
    }
    fileprivate class func listenStreamMsg() {
        let _ = SocketManager.default.messageSubject.bind(to: streamMsgHandle())
    }
    fileprivate class func listenOpenStream() {
        let _ = openStreamBehavior.bind(to: openStreamHandle())
    }
    fileprivate class func streamMsgHandle() -> AnyObserver<String> {
        return AnyObserver { event in
            if let str = event.element {
                if str.contains("<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\">") {
                    openStreamBehavior.accept(.startTLS)
                } else if str.contains("<proceed xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>") {
                    openStreamBehavior.accept(.secondStream)
                } else if str.contains("<stream:features><auth xmlns=\"http://jabber.org/features/iq-auth\"/><register xmlns=\"http://jabber.org/features/iq-register\"/></stream:features>") {
                    openStreamBehavior.accept(.ok)
                }
            }
        }
    }
    fileprivate class func openStreamHandle() -> AnyObserver<OpenStreamStep> {
        return AnyObserver { event in
            if let state = event.element {
                switch state {
                    case .fristStream:
                        openFristStream()
                        break
                    case .startTLS:
                        openStreamStartTLS()
                        break
                    case .secondStream:
                        openSecondStream()
                        break
                    case .ok:
                        openStreamOK()
                        break
                    default:
                        break
                }
            }
        }
    }
    fileprivate class func openFristStream() {
        Log("-------开始握手-------");
        Log("发送第一次Stream");
        let msg = "<stream:stream to=\"\(SocketManager.default.host)\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openStreamStartTLS() {
        Log("发送开启TLS的消息");
        let msg = "<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openSecondStream() {
        SocketManager.default.startTLS()
        Log("发送第二次Stream");
        let msg = "<stream:stream to=\"tcl.com\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openStreamOK() {
        Log("-------握手完成-------");
        LocalDeviceUdpTool.startSearchDevice()
    }
}

//MARK:心跳
extension SocketTool {
    class func sendHeart(){
        let heartMsg = "<?xml version=\"1.0\" encoding=\"utf-8\"?><iq id=\"heartMessage\" to=\"tcl.com\" type=\"get\"><ping xmlns=\"urn:xmpp:ping\"></ping></iq>"
        SocketManager.default.send(message: heartMsg)
    }
    fileprivate class func listenHeartMessage() {
        let _ = SocketManager.default.messageSubject.bind(to: heartMsgHandle())
    }
    fileprivate class func heartMsgHandle() -> AnyObserver<String> {
        return AnyObserver { event in
            if let str = event.element {
                if str.contains("heart_message") {
                    Log("收到心跳回包:\(str)")
                }
            }
        }
    }
}

