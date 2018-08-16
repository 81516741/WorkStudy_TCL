//
//  Extension_BasicStudy.swift
//  Swift学习
//
//  Created by TCL-MAC on 2018/8/15.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

import Foundation

extension ViewController{
    func switchUse() {
        let vegetable = "red pepper"
        switch vegetable {
        case "celery":
            print("Add some raisins and make ants on a log.")
        case "cucumber", "watercress":
            print("That would make a good tea sandwich.")
        case let x where x.hasSuffix("pepper"):
            print("Is it a spicy \(x)?")
        default:
            print("Everything tastes good in soup.")
        }
    }
    
    func forTest() {
        var total = 0
        for i in 0..<4 {
            total += i
        }
        print(total)
    }
    
    func sumOf(numbers: Int...) -> Int {
        var sum = 0
        for (_,number) in numbers.enumerated() {
            sum += number
        }
        return sum
    }
}

