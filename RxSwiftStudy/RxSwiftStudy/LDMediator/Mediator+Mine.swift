//
//  LDMediator+Mine.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/12/1.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
let kMediatorTargetMine = "Mine";
let kMediatorActionNativeFetchMineVC = "nativeFetchMineVC";

extension Mediator {
    func mine_getMineController()->UINavigationController? {
        let vc = performTarget(kMediatorTargetMine,
                      action: kMediatorActionNativeFetchMineVC,
                      params: ["title":"首页",
                               "image":"second_normal",
                               "selectedImage":"second_selected"],
                      shouldCacheTarget: false)
            as? UIViewController
        if let vc = vc {
            if vc.isKind(of: UIViewController.classForCoder()) {
                return UINavigationController.init(rootViewController: vc)
            }
        }
        return nil
    }
}
