//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by lingda on 2018/11/29.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    var bag = DisposeBag()
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTipLabel: UILabel!
    @IBOutlet weak var countTipLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        complexBind()
        ZDYGCZ()
    }
    @objc func Action_nativeFetchMineVC(params:NSDictionary) -> UIViewController{
        return ViewController()
    }
}

extension Reactive where Base : UIViewController {//自定义观察者
    public var bgColor:Binder<UIColor> {
        return Binder(self.base){(controller,color) in
            controller.view.backgroundColor = color
        }
    }
}
extension ViewController {//自定义观察者
    func ZDYGCZ() {
        let backOb = countTextField.rx.text.orEmpty.map{UIColor(red: CGFloat($0.count + 10)/30.0, green: CGFloat($0.count + 10)/50.0, blue: CGFloat($0.count + 10)/80.0, alpha: CGFloat($0.count + 5)/10.0)}.share(replay: 1)
        backOb.bind(to: self.rx.bgColor).disposed(by: bag)
    }
}

extension ViewController {//第一个例子
    func complexBind() {
        let minimalCountLength = 6
        let minimalPasswordLength = 6
        countTipLabel.text = "至少\(minimalCountLength)个字"
        passwordTipLabel.text = "至少\(minimalPasswordLength)个字"
        
        let countValid = countTextField.rx.text.orEmpty
            .map {$0.count >= minimalCountLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(
            countValid,
            passwordValid
        ) { $0 && $1 }
            .share(replay: 1)
        
        countValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: bag)
        
        countValid
            .bind(to: countTipLabel.rx.isHidden)
            .disposed(by: bag)
        
        passwordValid
            .bind(to: passwordTipLabel.rx.isHidden)
            .disposed(by: bag)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: bag)
        
        loginBtn.rx.observe(String.self, #keyPath(UIButton.isEnabled))
            .subscribe(onNext: {[weak self] newValue in
                if self!.loginBtn.isEnabled {
                    self!.loginBtn.backgroundColor = UIColor.blue
                } else {
                    self!.loginBtn.backgroundColor = UIColor.lightGray
                }
            })
            .disposed(by: bag)
        
        loginBtn.rx.tap
            .subscribe(onNext: {print("被点击了")})
            .disposed(by: bag)
        
    }
}

