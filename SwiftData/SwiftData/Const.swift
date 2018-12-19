//
//  File.swift
//  SwiftData
//
//  Created by lingda on 2018/12/19.
//  Copyright © 2018年 lingda. All rights reserved.
//

import Foundation

let isTest = true
func msgID(_ flag:String)->String {
    let date = NSDate()
    let uniquNum = Int(date.timeIntervalSince1970 * 1000) + Int(arc4random() % 10000)
    let msgID = "\(flag)（\(uniquNum)）"
    return msgID
}
