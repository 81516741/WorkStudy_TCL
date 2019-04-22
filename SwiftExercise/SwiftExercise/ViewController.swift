//
//  ViewController.swift
//  SwiftExercise
//
//  Created by lingda on 2019/4/20.
//  Copyright © 2019年 lingda. All rights reserved.
//

import UIKit

protocol Protocol1 {
    func run()
}
extension Protocol1 {
    func run() {
        print("------")
    }
}
class Animal:Protocol1 {
    func run() {
        print("动物跑")
    }
}
extension Animal {
    
}
extension Protocol1 where Self : Animal {
    func nimei() {
        print("show")
    }
}

class ViewController: UIViewController,Protocol1 {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        run()
        Animal().nimei()
    }

}

