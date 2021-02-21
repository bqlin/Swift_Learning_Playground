//
//  Todo+Request.swift
//  RxOnlineTodo
//
//  Created by Bq Lin on 2021/2/21.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum GetTodoListError: Error {
    case cannotConvertServerResponse
}

extension Todo {
    class func requestList(from router: TodoRouter) -> Observable<[[String: Any]]> {
        // 创建一个Observable
        return Observable.create { (observer) -> Disposable in
            let request = AF.request(TodoRouter.get(nil)).responseJSON { (response) in
                guard response.error == nil else {
                    //print(response.error!)
                    observer.onError(response.error!)
                    return
                }
                
                guard let todos = response.value as? [[String: Any]] else {
                    //print("Cannot read the Todo list from the server.")
                    observer.onError(GetTodoListError.cannotConvertServerResponse)
                    return
                }
                
                observer.onNext(todos)
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        
    }
}
