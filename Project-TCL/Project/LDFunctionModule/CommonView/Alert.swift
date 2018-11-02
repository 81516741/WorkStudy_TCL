//
//  Alert.swift
//  Project
//
//  Created by lingda on 2018/10/26.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class Alert: NSObject {
    fileprivate class func alertBase(title:String,message:String,btn1Title:String,btn2Title:String,desVC:UIViewController,type:UIAlertControllerStyle,clickBtn1:(()->())?,clickBtn2:(()->())?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: type)
        if btn1Title.count > 0 {
            let action1 = UIAlertAction(title: btn1Title, style: .default) { (action) in
                clickBtn1?()
            }
            alertVC.addAction(action1)
        }
        
        if btn2Title.count > 0 {
            let action2 = UIAlertAction(title: btn2Title, style: .default) { (action) in
                clickBtn2?()
            }
            alertVC.addAction(action2)
        }
        
        desVC.present(alertVC, animated: true, completion: nil)
    }
    
    class func  alert(title:String,message:String,btn1Title:String,btn2Title:String,desVC:UIViewController,clickBtn1:(()->())?,clickBtn2:(()->())?) {
        Alert.alertBase(title: title, message: message, btn1Title: btn1Title, btn2Title: btn2Title, desVC: desVC, type: .alert, clickBtn1: clickBtn1, clickBtn2: clickBtn2)
    }
    
    class func  actionSheet(title:String,message:String,btn1Title:String,btn2Title:String,desVC:UIViewController,clickBtn1:(()->())?,clickBtn2:(()->())?) {
        Alert.alertBase(title: title, message: message, btn1Title: btn1Title, btn2Title: btn2Title, desVC: desVC, type: .actionSheet, clickBtn1: clickBtn1, clickBtn2: clickBtn2)
    }
}
