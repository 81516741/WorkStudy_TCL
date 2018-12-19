//
//  LDHomeVC.swift
//  Project
//
//  Created by lingda on 2018/10/16.
//  Copyright © 2018年 令达. All rights reserved.
//

import UIKit

class LDHomeVC: UIViewController {
    var topStatusBarHeight : CGFloat {
        get {
            if LDSysTool.deviceType()! == "iphone X" {
                return 30
            } else {
                return 20
            }
        }
    }
    var topSelectViewHeight : CGFloat = TransFormTool.transPXToIphoneSize(pxValue: 145)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ld_hideNavigationBar = true
        configSubViews()
        addNoti()
        netRequest()
    }
    
    func configSubViews() {
        view.addSubview(topBarSelectView)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(deviceCollectionView)

    }
    
    lazy var deviceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: TransFormTool.transPXToIphoneSize(pxValue: 358), height: TransFormTool.transPXToIphoneSize(pxValue: 288))
        layout.minimumLineSpacing = TransFormTool.transPXToIphoneSize(pxValue: 20)
        layout.minimumInteritemSpacing = TransFormTool.transPXToIphoneSize(pxValue: 20)
        layout.sectionInset = UIEdgeInsetsMake(TransFormTool.transPXToIphoneSize(pxValue: 36), TransFormTool.transPXToIphoneSize(pxValue: 36), TransFormTool.transPXToIphoneSize(pxValue: 36), TransFormTool.transPXToIphoneSize(pxValue: 36))
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height - topStatusBarHeight - topSelectViewHeight-49), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeviceCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.RGB(r: 243, g: 247, b: 250, a: 1)
        return collectionView
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.delegate = self
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 0)
        contentScrollView.frame = CGRect(x: 0, y: topStatusBarHeight + topSelectViewHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (topStatusBarHeight + topSelectViewHeight + 49))
        return contentScrollView
    }()
    
    lazy var topBarSelectView: TopBarSelectView = {
        let top = TopBarSelectView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topSelectViewHeight + topStatusBarHeight))
        top.firstItem.titleLabel.text = "设备"
        top.secondItem.titleLabel.text = "场景"
        top.clickItemHandle = {[weak self](index) in
            self?.clickTopItem(index: index)
        }
        return top
    }()
    
}
//MARK:collection View delegate and dataSource
extension LDHomeVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let deviceList = LDDBTool.getDeviceList() {
            return deviceList.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DeviceCell
        let model = LDDBTool.getDeviceList()[indexPath.row] as! DeviceModel
        cell.updateCellViews(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = LDDBTool.getDeviceList()[indexPath.row] as! DeviceModel
        let webVC = H5CtrCV()
        webVC.deviceObj = model
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    
}

//MARK:scroll View delegate
extension LDHomeVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            topBarSelectView.selectedIndex = 0
        } else if scrollView.contentOffset.x == UIScreen.main.bounds.width {
            topBarSelectView.selectedIndex = 1
        }
    }
}

//MARK:点击等事件
extension LDHomeVC {
    func clickTopItem(index:NSInteger) {
        if index == 0 {
            contentScrollView.contentOffset = CGPoint(x: 0, y: 0)
        } else {
            contentScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.size.width, y: 0)
        }
    }
}

//MARK:通知相关
extension LDHomeVC {
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(autoLoginFailure), name: NSNotification.Name.autoLoginFailure, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(otherDeviceLoginNoti(noti:)), name: NSNotification.Name.otherDeviceLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChange), name: NSNotification.Name.loginStateChange, object: nil)
    }
    
    
    @objc func autoLoginFailure() {
        LDConfigVCUtil.configLoginVC(toRootVC: true)
    }
    
    @objc func otherDeviceLoginNoti(noti:Notification) {
        Alert.alert(title: "异地登录提醒", message: "您的账号在另一台\(noti.object as! String)登录了", btn1Title: "退出", btn2Title: "重新登录", desVC: self, clickBtn1: {
            LDDBTool.updateConfigModelOtherDeviceLoginState(myDeviceLoginOut)
        }) {
            LDDBTool.updateConfigModelOtherDeviceLoginState(myDeviceRelogin)
            LDSocketTool.sendHearMessge()
        }
    }
    
    @objc func loginStateChange() {
        if LDSocketTool.shared().loginState == "0" {
            DispatchQueue.main.async {
                MBProgressHUD.showTipMessage(inWindow: "已经连接，隐藏无网络提醒")
            }
        } else {
            DispatchQueue.main.async {
                
                MBProgressHUD.showTipMessage(inWindow: "断开连接，显示无网络提醒")
            }
        }
    }
}
//MARK:网络请求
extension LDHomeVC {
    fileprivate func netRequest() {
        DispatchQueue.global().async {
            if LDSocketTool.shared().loginState == "1" {
                while true {
                    sleep(1)
                    if LDSocketTool.shared().loginState == "0" {
                        self.allRequest()
                        break
                    }
                }
            } else {
                self.allRequest()
            }
        }
    }
    
    fileprivate func allRequest() {
        LDSocketTool.getDeviceListSuccess({ (data) in
            self.deviceCollectionView.reloadData()
        }, failure: nil)
        LDSocketTool.getSceneListSuccess(nil, failure: nil)
        LDSocketTool.getUserInfoSuccess(nil, failure: nil)
    }
}
