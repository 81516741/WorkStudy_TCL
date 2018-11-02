//
//  TransformTool.swift
//  TclIntelliCom
//
//  Created by TCL-MAC on 2018/8/14.
//  Copyright © 2018年 tcl. All rights reserved.
//

import Foundation

class TransFormTool:NSObject {
    class func transFormHanYuToPingYin(str:NSString)->NSString {
        let pinyin = str.mutableCopy() as! CFMutableString
        CFStringTransform(pinyin, nil, kCFStringTransformToLatin, false)
        print("被转的汉字是:\(str),转换后是:\(pinyin)")
        return pinyin
    }
    
    class func transFontSize(fontSize:CGFloat) -> UIFont{
        let size = self.transPXToIphoneSize(pxValue: fontSize)
        return UIFont.systemFont(ofSize: size)
    }
    
    class func transPXToIphoneSize(pxValue:CGFloat) -> CGFloat{
        let size = (pxValue * UIScreen.main.bounds.width / 414.0) * 0.5
        return size;
    }
    
}
