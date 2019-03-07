//
//  ViewController1.swift
//  RxSwiftStudy
//
//  Created by lingda on 2019/2/22.
//  Copyright © 2019年 lingda. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(TestView.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
    }
    
    override func routerEventWithType(eventType: String, userInfo: Any?) {
        print(eventType + "\(userInfo)")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(ViewController2(), animated: true)
    }
    
}
