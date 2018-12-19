//
//  LogTool.swift
//  SwiftData
//
//  Created by lingda on 2018/12/18.
//  Copyright © 2018年 lingda. All rights reserved.
//

import Foundation

func Log<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    if isTest {
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):(\(lineNum))-\(messsage)")
    }
}
