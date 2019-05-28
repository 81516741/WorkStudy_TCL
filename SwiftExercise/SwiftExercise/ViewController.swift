//
//  ViewController.swift
//  SwiftExercise
//
//  Created by lingda on 2019/4/20.
//  Copyright © 2019年 lingda. All rights reserved.
//

import UIKit

//MARK: - 面向协议编程的示例
enum HTTPMethod: String {
    case GET
    case POST
}
protocol Client {
    func send<T:Request>(_ r:T,handler: @escaping (T.Response?) -> Void)
    var host:String{get}
}
struct URLSessionClient:Client {
    let host = "https://www.dashuai.com"
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
    associatedtype Response:Decodable
}

struct UserRequest: Request {
    let name: String
    let host = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String: Any] = [:]
    typealias Response = User
    func parse(data: Data)->Response? {
        return User(data: data) ?? nil
    }
}
protocol Decodable {
    static func parse(data:Data)->Self?
}


struct User:Decodable {
    let name:String
    let message:String
    init?(data:Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            return nil
        }
        guard let name = obj?["name"] as? String else { return nil }
        guard let message = obj?["message"] as? String else { return nil }
        self.message = message
        self.name = name
    }
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}



class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

