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
class SocketTool: NSObject {
    static let openStreamBehavior = BehaviorRelay<OpenStreamStep>(value: .none)
    static var blocks = [[String:((String)->())]]()
    
    class func send(message msg:String,result:@escaping ((String)->())) {
        if openStreamBehavior.value == .none {
            result("当前网络未连接")
            return
        }
        addBlock(msg, result)
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
        let _ = SocketManager.messageSubject.bind(to: msgHandle())
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
    fileprivate class func addBlock(_ message:String,_ block:@escaping ((String)->())) {
        let msgID = "消息ID"
        blocks.append([msgID:block])
        if blocks.count > 100 {
            blocks.removeFirst()
        }
    }
    class func callBack(_ message:String) {
        let msgID = "消息ID"
        for value in blocks {
            if let key = value.keys.first {
                if key == msgID {
                    DispatchQueue.main.async {
                       value.values.first?(message)
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
        let _ = SocketManager.messageSubject.bind(to: streamMsgHandle())
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
                } else if str.contains("xmlns:stream=\"http://etherx.jabber.org/streams\"") {
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
                        //openStreamStartTLS()
                        break
                    case .secondStream:
                        //openSecondStream()
                        break
                    case .ok:
                        //openStreamOK()
                        break
                    default:
                        break
                }
            }
        }
    }
    fileprivate class func openFristStream() {
        let msg = "<stream:stream to=\"\(SocketManager.default.host)\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openStreamStartTLS() {
        let msg = "<starttls xmlns=\"urn:ietf:params:xml:ns:xmpp-tls\"/>"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openSecondStream() {
        startSSL()
        let msg = "<stream:stream to=\"tcl.com\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">"
        SocketManager.default.send(message: msg)
    }
    fileprivate class func openStreamOK() {
        
    }
    
    fileprivate class func startSSL() {
        
    }
}

//MARK:心跳
extension SocketTool {
    class func sendHeart(){
        let heartMsg = "<?xml version=\"1.0\" encoding=\"utf-8\"?><iq id=\"heartMessage\" to=\"tcl.com\" type=\"get\"><ping xmlns=\"urn:xmpp:ping\"></ping></iq>"
        SocketManager.default.send(message: heartMsg)
    }
    fileprivate class func listenHeartMessage() {
        let _ = SocketManager.messageSubject.bind(to: heartMsgHandle())
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

