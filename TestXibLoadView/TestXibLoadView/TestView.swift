//
//  TestView.swift
//  TestXibLoadView
//
//  Created by lingda on 2019/4/25.
//  Copyright © 2019年 lingda. All rights reserved.
//
//  github:https://github.com/81516741
//

import UIKit

class TestViewContent: UIView {
//    @IBOutlet weak var <#name#>: <#name#>!
}

class TestView: UIView {
    //MARK: - property
    private var contentView:TestViewContent?
    private var isInstanceLoadView = false
    //@IBOutlet weak var <#name#>: <#name#>!
    
    //MARK: - handle
    //var <#name#>Handle:(()->())?
    
    //MARK: - UI
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView = TestView.addXibView(xibView: self)
        configUI()
        addClick()
    }
    func configUI() {
        
    }
    
    //MARK: - click
    func addClick() {
        
    }
    
    //MARK: - method of change UI
}

//MARK: - delegate
extension TestView {
    
}
//MARK: - load xibView common method
extension TestView {
//    这个用于代码生成对象
//    class func instance()-> TestView {
//        let view = loadXibView() as! TestView
//        view.isInstanceLoadView = true
//        return view
//    }
    class func addXibView(xibView:TestView)->TestViewContent? {
        if xibView.isInstanceLoadView { return nil}
        let view = loadXibView(owner: xibView)
        xibView.addSubview(view)
        
        return view as? TestViewContent
    }
    class func loadXibView(owner:Any?)->UIView {
        var xibView:UIView!
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        let views = Bundle.init(for: self).loadNibNamed(className, owner: owner, options: nil)
        for view in views! {
            if !(view as! NSObject).isKind(of: UIControl.self) {
                xibView = view as? UIView
            }
        }
        return xibView
    }
}
