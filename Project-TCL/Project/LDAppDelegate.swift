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
        LDDBTool.createDatabaseAndAllTable()
        LDConfigVCUtil.config(true)
        LDLogTool.configDDLog()
        LDSocketTool.startConnectAndHeart()
    }
}
