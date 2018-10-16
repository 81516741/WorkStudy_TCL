//
//  LDLoginSocket.swift
//  Project
//
//  Created by lingda on 2018/10/15.
//  Copyright © 2018年 令达. All rights reserved.
//

import Foundation

extension LDSocketTool {
    class func getCountByPhoneNum(phoneNum:String,success:@escaping LDSocketToolBlock,failure:@escaping LDSocketToolBlock) {
        if let messageID = getMessageID(kGetCountMessageIDPrefix) {
            let message = """
            <?xml version=\"1.0\" encoding=\"utf-8\"?>
            <iq id=\"\(messageID)\" type=\"get\">
            <bundling xmlns=\"jabber:iq:checkguide\">
            <type>tel</type>
            <username>\(phoneNum)</username>
            </bundling>
            </iq>
            """
            LDSocketTool.sendMessage(message, messageID: messageID, success: success, failure: failure)
        }
    }
    
    class func login(userID:String,password:String,success:@escaping LDSocketToolBlock,failure:@escaping LDSocketToolBlock) {
        if let messageID = getMessageID(kLoginMessageIDPrefix) {
            let dic = [
                "joinid":LDSysTool.joinID(),
                "configversion":"10310",
                "lang":LDSysTool.languageType(),
                "devicetype":LDSysTool.deviceType(),
                "company":LDSysTool.company(),
                "version":LDSysTool.version(),
                "token":LDSysTool.uuidString(),
                "type":LDSysTool.tid(),
                "pwd":password.sha1
                ] as [String : Any]
            if let passwordStr = LDSocketTool.dic(toStr: dic) {
                let message = """
                <?xml version=\"1.0\" encoding=\"utf-8\"?>\
                    <iq type=\"set\" id=\"\(messageID)\">\
                        <query xmlns=\"jabber:iq:auth\">\
                            <username>\(userID)</username>\
                            <resource>PH-ios-zx01-4</resource>\
                            <password>\(passwordStr)</password>\
                        </query>\
                    </iq>"
                """
                LDSocketTool.sendMessage(message, messageID: messageID, success: success, failure: failure)
            }
            
        }
    }
    
    class func login(num:String,password:String,success:@escaping LDSocketToolBlock,failure:@escaping LDSocketToolBlock) {
        if num.count == 11 {
            getCountByPhoneNum(phoneNum: num, success: success, failure: failure)
        } else if num.count == 7 {
            login(num: num, password: password, success: success, failure: failure)
        }
    }
    
    public func receiveLoginModuleMessage(_ message: String!, messageIDPrefix: String!, success: LDSocketToolBlock!, failure: LDSocketToolBlock!) {
        let data = message as NSString
        if messageIDPrefix == kGetCountMessageIDPrefix {
            handleGetCountMessage(message: data, success: success, failure: failure)
        } else if messageIDPrefix == kLoginMessageIDPrefix {
            handleGetCountMessage(message: data, success: success, failure: failure)
        }
    }
    func handleGetCountMessage(message:NSString,success:LDSocketToolBlock,failure:LDSocketToolBlock) {
        if message.tcl_errorCode == "0" {
            success(message.tcl_userID)
        } else {
            failure(getErrorDescription(message.tcl_errorCode))
        }
    }
    func handleLoginMessage(message:NSString,success:LDSocketToolBlock,failure:LDSocketToolBlock) {
        if message.tcl_errorCode == nil {
            success(nil)
        } else if (message.tcl_errorCode == "401") {
            failure("认证失败")
        } else if (message.tcl_errorCode == "403") {
            failure("禁用")
        } else if (message.tcl_errorCode == "404") {
            failure("账号不存在")
        } else if (message.tcl_errorCode == "405") {
            failure("连续3次密码错误")
            
        }
    }
}


