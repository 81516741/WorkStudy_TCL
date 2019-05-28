//
//  SwizzleProtocal.swift
//  SwiftRuntime
//
//  Created by lingda on 2019/5/28.
//  Copyright © 2019年 lingda. All rights reserved.
//
import UIKit

protocol SwizzleProtocol {
    static func swizzle()
    static func swizzle(origin:Selector,des:Selector)
}

extension SwizzleProtocol where Self:NSObject {
    static func swizzle(origin:Selector,des:Selector) {
        guard let m1 = class_getInstanceMethod(self, origin) else {
            return
        }
        guard let m2 = class_getInstanceMethod(self, des) else {
            return
        }
        if (class_addMethod(self, des, method_getImplementation(m2), method_getTypeEncoding(m2))) {
            class_replaceMethod(self, des, method_getImplementation(m1), method_getTypeEncoding(m1))
        } else {
            method_exchangeImplementations(m1, m2)
        }
    }
}

class Swizzle {
    static func swizzleAll() {
        let count = Int(objc_getClassList(nil, 0))
        let classes = UnsafeMutablePointer<AnyClass?>.allocate(capacity: count)
        let autoreleaseClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        objc_getClassList(autoreleaseClasses, Int32(count))
        for index in 0..<count {
            (classes[index] as? SwizzleProtocol.Type)?.swizzle()
        }
        classes.deallocate()
    }
}
