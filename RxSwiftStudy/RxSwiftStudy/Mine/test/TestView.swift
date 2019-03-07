//
//  TestView.swift
//  RxSwiftStudy
//
//  Created by lingda on 2019/2/26.
//  Copyright © 2019年 lingda. All rights reserved.
//

import UIKit

class TestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        routerEventWithType(eventType: "nimei", userInfo: "dddd")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
