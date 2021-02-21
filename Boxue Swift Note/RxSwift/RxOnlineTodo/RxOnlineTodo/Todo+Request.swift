//
//  Todo+Request.swift
//  RxOnlineTodo
//
//  Created by Bq Lin on 2021/2/21.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation
import Alamofire

extension Todo {
    class func list() {
        AF.request(TodoRouter.get(nil)).responseJSON { (response) in
            guard response.error == nil else {
                print(response.error!)
                return
            }
            
            guard let todos = response.value as? [[String: Any]] else {
                print("Cannot read the Todo list from the server.")
                return
            }
            
            todos.prefix(upTo: 10).reversed().forEach { (json) in
                guard let todo = Todo(json: json) else {
                    print("Cannot create a todo from the JSON.")
                    return
                }
                
                // self.todoList.append(todo)
            }
            
            // TODO: update table view
        }
    }
}
