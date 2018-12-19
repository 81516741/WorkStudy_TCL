//
//  ViewController.swift
//  SwiftData
//
//  Created by lingda on 2018/12/3.
//  Copyright © 2018年 lingda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm


class ViewController: UIViewController {
    let bag = DisposeBag()
    var models : Results<Model0>!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ConnectSocketTool.connectSocket()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        netRequest()
        //查 增 删 改
        models = DBTool.getModels()
        addButton.rx.tap.subscribe(onNext:{
            let model = Model0()
            let reply = Reply0()
            model.reply = reply
            DBTool.saveModel(model: model)
        }).disposed(by: bag)
        deleteButton.rx.tap
            .map{[unowned self] in self.models.last ?? Model0()}
            .bind(to: DBTool.delete())
            .disposed(by: bag)
        changeButton.rx.tap.subscribe({_ in
            DBTool.updateLastModelReplyPort(port: "你好啊")
        }).disposed(by: bag)
        
        
        Observable.collection(from: models)
            .map{"数据库有\($0.count)条数据"}
            .subscribe(onNext:{[unowned self] in
            self.titleLabel.text = $0
        }).disposed(by: bag)
        Observable.changeset(from: models)
            .subscribe(onNext:{[unowned self] result,changes in
                if let changes = changes {
                    Log("有变化")
                    Log(changes)
                    self.tableView.applyChangeset(changes)
                } else {
                    Log("没有变化")
                    self.tableView.reloadData()
                }
            }).disposed(by: bag)
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        
    }
    
    @IBAction func sendHeart(_ sender: Any) {
        
    }
    
    func netRequest() {
        HTTPTool.getIPSaveDB(count: "2004050", bag: bag, success: { (model:Model0) in
            Log(model)
            DBTool.saveModel(model: model)
        }, failure: nil)
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let reply = models[indexPath.row]
        cell?.textLabel?.text = reply.reply?.port ?? "默认的"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
}

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}

