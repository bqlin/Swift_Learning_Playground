//
//  TodoListViewController.swift
//  RxOnlineTodo
//
//  Created by Bq Lin on 2021/2/21.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit
import Alamofire

class TodoListViewController: UITableViewController {
    
    var todoList: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
