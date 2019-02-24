//
//  LDAppDelegate.swift
//  Project
//
//  Created by lingda on 2018/10/15.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class LDAppDelegate : UIResponder,UIApplicationDelegate  {
    var window: UIWindow?
    func applicationDidFinishLaunching(_ application: UIApplication) {
        LDLogTool.configDDLog()
        LDDBTool.createDatabaseAndAllTable()
        LDDBTool.updateConfigModelOtherDeviceLoginState(otherDeviceLoginStateNone)
        LDConfigVCUtil.config(false)
        LDSocketTool.startConnectAndHeart()
    }
}
