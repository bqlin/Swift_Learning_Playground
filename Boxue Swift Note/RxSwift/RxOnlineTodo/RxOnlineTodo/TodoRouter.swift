//
//  TodoRouter.swift
//  RxOnlineTodo
//
//  Created by Bq Lin on 2021/2/21.
//  Copyright © 2021 Bq. All rights reserved.
//

import Alamofire
import Foundation

/*:
 目标是构建URLRequestConvertible，便于Alamofire的AF.request方法的调用。这样调用不同的接口就直接传入对应的枚举值即可。
 */
enum TodoRouter: URLRequestConvertible {
    static let baseURL: String = "https://jsonplaceholder.typicode.com/"
    
    // 获取对应的todo项
    case get(Int? = nil)
    
    // URLRequestConvertible协议方法
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
                case .get:
                    return .get
            }
        }
        
        var params: [String: Any]? {
            switch self {
                case .get:
                    return nil
            }
        }
        
        var url: URL {
            var relativeUrl: String = "todos"
            
            switch self {
                case .get(let todoId):
                    if todoId != nil {
                        relativeUrl = "todos/\(todoId!)"
                    }
            }
            
            let url = URL(string: TodoRouter.baseURL)!.appendingPathComponent(relativeUrl)
            
            return url
        }
        
        // 构建URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let encoding = JSONEncoding.default
        return try encoding.encode(request, with: params)
    }
}
