//
//  ViewController.swift
//  Swift_Study
//
//  Created by TCL-MAC on 2018/8/15.
//  Copyright © 2018年 TCL-MAC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class ViewController: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<MySection>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigTableView()
        NotificationCenter.default.rx.notification(.UIApplicationDidEnterBackground).subscribe(onNext:{
                print($0)
            
            
        }).disposed(by: disposeBag)
    }
}

extension ViewController {
    func ConfigTableView() {
        //用RxDataSources配置tableView
        dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell1") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell1")
                cell.textLabel?.text = "Item \(item)"
                return cell
        },
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        },
            titleForFooterInSection: { ds, index in
                return ds.sectionModels[index].footer
        })
        
        let sections = [
            MySection(header: "First section",footer:"Fist Footer" ,items: [
                1,
                2
                ]),
            MySection(header: "Second section",footer:"Second Footer" , items: [
                3,
                4
                ])
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let item = dataSource?[indexPath],
            let data = dataSource?[indexPath.section]
            else {
                return 0.0
        }
        print(item)
        print(data)
        return CGFloat(40 + item * 10)
    }
}

struct MySection {
    var header: String
    var footer: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = Int
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}


