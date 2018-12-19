//
//  HTTPTool.swift
//  RxMoya
//
//  Created by lingda on 2018/12/4.
//  Copyright © 2018年 ZhaoHeng. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON
import Realm
import Alamofire

class HTTPTool : NSObject {
    class func getIP(count:String,success: ((Model)->())?,failure:((String)->())?) {
        let provider = MoyaProvider<HTTPLoginServices>(manager:myMrg)
        let _ = provider.rx.request(.getIP(count))
            .map(Model.self).subscribe { result in
            switch result {
            case .success(let element):
                success?(element!)
            case .error(let error):
                failure?(error.localizedDescription)
            }}
        }
    
    class func getIPSaveDB(count:String,bag:DisposeBag,success: ((Model0)->())?,failure:((String)->())?) {
        let provider = MoyaProvider<HTTPLoginServices>()
        provider.rx.request(.getIP(count))
            .map().subscribe { result in
                switch result {
                case .success(let json):
                    let replys = Reply0.mj_objectArray(withKeyValuesArray: json!["replys"].rawValue) as![Reply0]
                    let model0 = Model0.mj_object(withKeyValues: json!.rawValue)
                    model0?.replyList.append(objectsIn: replys)
                    success?(model0!)
                    break
                case .error(let error):
                    failure?(error.localizedDescription)
                }}.disposed(by: bag)
    }
}



