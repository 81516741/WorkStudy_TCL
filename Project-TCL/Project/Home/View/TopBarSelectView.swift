//
//  TopBarSelectView.swift
//  Project
//
//  Created by lingda on 2018/10/29.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class TopBarSelectView: UIView {
    
    let bag = DisposeBag()
    
    var clickItemHandle:((NSInteger)->(Void))?
    
    var selectedIndex : NSInteger {
        didSet {
            if selectedIndex == 0 {
                firstItem.selected = true
                secondItem.selected = false
            } else {
                firstItem.selected = false
                secondItem.selected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        self.selectedIndex = 0
        super.init(frame: frame)
        configView(frame0: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(frame0:CGRect) {
        backgroundColor = UIColor.hexadecimalColor(hexadecimal: "3a445a")
        var statusBarHeight : CGFloat = 20.0
        if let deviceType = LDSysTool.deviceType() {
            if deviceType == "iPhone X" {
                statusBarHeight = 30.0
            }
        }
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        bottomView.frame = CGRect(x: CGFloat(0), y: statusBarHeight, width: CGFloat(frame0.width), height: TransFormTool.transPXToIphoneSize(pxValue: 145))
        addSubview(bottomView)
        bottomView.addSubview(firstItem)
        bottomView.addSubview(secondItem)
        
        //约束
        firstItem.mas_makeConstraints{
            $0?.left.equalTo()(TransFormTool.transPXToIphoneSize(pxValue: 54))
            $0?.centerY.equalTo()(bottomView)
            $0?.width.equalTo()(TransFormTool.transPXToIphoneSize(pxValue: 140))
            $0?.height.equalTo()(TransFormTool.transPXToIphoneSize(pxValue:145))
        }
        
        secondItem.mas_makeConstraints{
            $0?.left.equalTo()(firstItem.mas_right)?.offset()(TransFormTool.transPXToIphoneSize(pxValue: 20))
            $0?.centerY.equalTo()(bottomView)
            $0?.width.equalTo()(TransFormTool.transPXToIphoneSize(pxValue: 140))
            $0?.height.equalTo()(TransFormTool.transPXToIphoneSize(pxValue:145))
        }
        selectedIndex = 0
        
        //事件
        firstItem.rx.tapGesture().when(.recognized).subscribe { [weak self](ges) in
            self!.selectedIndex = 0
            self!.clickItemHandle?(0)
        }.disposed(by: bag)
        secondItem.rx.tapGesture().when(.recognized).subscribe { [weak self](ges) in
            self!.selectedIndex = 1
            self!.clickItemHandle?(1)
            }.disposed(by: bag)
        
    }
    
    lazy var firstItem:topWordBottomLineView = {
        let item = topWordBottomLineView()
        return item
    }()
    lazy var secondItem:topWordBottomLineView = {
        let item = topWordBottomLineView()
        return item
    }()
}

class topWordBottomLineView : UIView {
    let selectedColor = UIColor.hexadecimalColor(hexadecimal: "20d3ab")
    let normalColor = UIColor.white
    
    var selected:Bool {
        didSet {
            if selected {
                titleLabel.textColor = selectedColor
                bottomLine.isHidden = false
            } else {
                titleLabel.textColor = normalColor
                bottomLine.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        selected = false
        super.init(frame: frame)
        configView(frame0: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configView(frame0: CGRect) {
        addSubview(titleLabel)
        addSubview(bottomLine)
        titleLabel.mas_makeConstraints {
            $0?.center.equalTo()(self)
        }
        bottomLine.mas_makeConstraints{
            $0?.centerX.equalTo()(self)
            $0?.bottom.equalTo()(self.mas_bottom)?.offset()(TransFormTool.transPXToIphoneSize(pxValue: -20))
            $0?.width.equalTo()(TransFormTool.transPXToIphoneSize(pxValue: 148))
            $0?.height.equalTo()(TransFormTool.transPXToIphoneSize(pxValue: 4))
        }
    }
    
    lazy var titleLabel:UILabel = {
       let label = UILabel()
        label.font = TransFormTool.transFontSize(fontSize: 54)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var bottomLine:UIView = {
       let line = UIView()
        line.backgroundColor = selectedColor
        return line
    }()
}
