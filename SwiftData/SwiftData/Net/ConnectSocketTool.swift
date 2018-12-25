//
//  ConnectSocketTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class ConnectSocketTool: NSObject {
    static let hostPortOB: Observable<[String]> = Observable.create { observer -> Disposable in
        let disposable = HTTPTool.getIP(count: "2004050", success: { (model:Model) in
            if let host = model.reply?.myIP,let port = model.reply?.port {
                observer.onNext([host,port])
                observer.onCompleted()
            }
        }, failure: { (err) in
            Log(err)
        })
        return disposable
    }
    static var posables = [Disposable]()
    static var timerHeart:DispatchSourceTimer?
    static var timerAddress:DispatchSourceTimer?
    class func connectSocket() {
        SocketTool.prepareSocket()
        NetCheckTool.checkNet()
        //监听开流状态
        let _ = SocketTool.openStreamBehavior.bind(to: openStreamHandle())
        //监听连接状态
        let _ = SocketManager.default.connectRelay.bind(to: connectStateHandle())
        //监听网络网络
        let _ = NetCheckTool.netState.bind(to: netStateHandle())
    }
    fileprivate class func openStreamHandle() -> AnyObserver<OpenStreamStep> {
        return AnyObserver { event in
            if let openStreanStep = event.element {
                if openStreanStep == .ok {
                    SocketLoginTool.autoLogin()
                    startHeart()
                }
            }
        }
    }
    fileprivate class func connectStateHandle() -> AnyObserver<ConnectState> {
        return AnyObserver { event in
            if let state = event.element {
                if state == .connected {//连接成功
                    SocketTool.openStream()
                } else if state == .disConnect {
                    SocketTool.openStreamBehavior.accept(.none)
                    stopHeart()
                    //有网络才去重连,且存在host 和 port
                    if NetCheckTool.netState.value == .hasNet {
                        SocketTool.buildConnect(toHost: SocketManager.default.host, toPort: SocketManager.default.port)
                    }
                }
            }
        }
    }
    fileprivate class func netStateHandle() -> AnyObserver<NetState> {
        return AnyObserver { event in
            if let netState = event.element {
                if netState == .hasNet {
                    //已经获取了port 和 host
                    if SocketManager.default.port.count != 0 && SocketManager.default.host.count != 0 {
                        SocketTool.buildConnect(toHost: SocketManager.default.host, toPort: SocketManager.default.port)
                    } else {
                        timerAddress = startTimer(timeInterval: 0.5) {
                            if NetCheckTool.netState.value == .hasNet {
                                posables.append(hostPortOB.bind(to: connect()))
                            }
                        }
                    }
                }
            }
        }
    }
    fileprivate class func connect() -> AnyObserver<[String]> {
        return AnyObserver { event in
            if let host = event.element?.first,let port = event.element?.last {
                if let timer = timerAddress {
                    timer.cancel()
                    self.timerAddress = nil
                }
                if SocketManager.default.host.count > 0 {
                    for ob in posables { ob.dispose() }
                } else {
                    SocketTool.buildConnect(toHost: host, toPort: port)
                }
            }
        }
    }
    fileprivate class func startHeart() {
        Log("-------开启心跳-------")
        stopHeart()
        timerHeart = startTimer(timeInterval: 20){SocketTool.sendHeart()}
    }
    fileprivate class func stopHeart() {
        if let timer = timerHeart {
            timer.cancel()
            self.timerHeart = nil
        }
    }
    class func startTimer(timeInterval:TimeInterval,handler:@escaping (()->()))->DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async { handler() }
        }
        timer.resume()
        return timer
    }
}
