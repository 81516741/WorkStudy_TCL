//
//  DeviceCell.swift
//  Project
//
//  Created by lingda on 2018/10/29.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class DeviceCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = TransFormTool.transPXToIphoneSize(pxValue: 8)
        layer.masksToBounds = true
        addSubview(deviceImageView)
        deviceImageView.mas_makeConstraints{
            $0?.centerX.equalTo()(self)
            $0?.size.equalTo()(CGSize(width: 50, height: 50))
            $0?.top.equalTo()(10)
        }
        addSubview(titleLabel)
        titleLabel.mas_makeConstraints{
            $0?.top.equalTo()(deviceImageView.mas_bottom)?.offset()(10)
            $0?.left.equalTo()(self)
            $0?.right.equalTo()(self.mas_right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var deviceImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexadecimalColor(hexadecimal: "4f5c7a")
        label.font = TransFormTool.transFontSize(fontSize: 38)
        label.textAlignment = .center
        return label
    }()
}
