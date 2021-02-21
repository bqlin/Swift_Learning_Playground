//
//  TodoListViewController.swift
//  RxOnlineTodo
//
//  Created by Bq Lin on 2021/2/21.
//  Copyright © 2021 Bq. All rights reserved.
//

import Alamofire
import RxSwift
import UIKit

class TodoListViewController: UITableViewController {
    var todoList: [Todo] = []
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let todoId: Int? = nil
        Observable.just(todoId)
            // 生成Observable<TudoRouter>
            .map { todoId in
                TodoRouter.get(todoId)
            }
            // 网络请求得到todo list
            .flatMap { route in
                Todo.requestList(from: route)
            }
            // 订阅，更新UI
            .subscribe(onNext: { todos in
                self.todoList = todos.compactMap { Todo(json: $0) } // 这里不直接用map是为了去除其中的Optional
                self.tableView.reloadData()
            }, onError: { error in
                print(error.localizedDescription)
            }).disposed(by: bag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo", for: indexPath)

        let todoItem = todoList[indexPath.row]
        let title = todoItem.title
        let richTitle = NSMutableAttributedString(string: title)
        if todoItem.completed {
            richTitle.setAttributes([.strikethroughStyle: 2], range: NSRange(location: 0, length: richTitle.length))
        }
        cell.textLabel?.attributedText = richTitle

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
