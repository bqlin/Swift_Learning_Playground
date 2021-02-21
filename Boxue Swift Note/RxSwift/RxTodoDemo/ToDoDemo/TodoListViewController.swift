//
//  ViewController.swift
//  TodoDemo
//
//  Created by Mars on 24/04/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import RxSwift

/// Todo 列表页面
class TodoListViewController: UIViewController {
    // 将 model 改为响应式，并添加回收包
    //var todoItems: [TodoItem] = []
    let todoItems = Variable<[TodoItem]>([])
    let bag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearTodoBtn: UIButton!
    @IBOutlet weak var addTodo: UIBarButtonItem!
    
    // 在 coder 过程中加载反序列化模型
    required init?(coder aDecoder: NSCoder) {
        // 我们已经不需要在这里初始化 `todoItems` 了
        //todoItems = [TodoItem]()
    
        super.init(coder: aDecoder)
        loadTodoItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        
        todoItems.asObservable().subscribe(onNext: { [weak self] todos in
            self?.updateUI(todos: todos)
        }).disposed(by: bag)
    }
    
    func updateUI(todos: [TodoItem]) {
        clearTodoBtn.isEnabled = !todos.isEmpty
        addTodo.isEnabled = todos.filter { !$0.isFinished }.count < 5
        title = todos.isEmpty ? "Todo" : "\(todos.count) ToDos"
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let todoDetailController = navigationController.topViewController as! TodoDetailViewController
        
        if segue.identifier == "AddTodo" {
            todoDetailController.title = "Add Todo"
            
            // 监听 todo
            _ = todoDetailController.todo.subscribe(onNext: { [weak self] (newTodo) in
                self?.todoItems.value.append(newTodo)
            }, onError: nil, onCompleted: nil) {
                print("Finish adding a new todo.")
            }
        } else if segue.identifier == "EditTodo" {
            todoDetailController.title = "Edit Todo"
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                todoDetailController.todoItem = todoItems.value[indexPath.row]
                
                _ = todoDetailController.todo.subscribe(onNext: { [weak self] (todo) in
                    // 触发 UI 更新
                    self?.todoItems.value[indexPath.row] = todo
                }, onError: nil, onCompleted: nil, onDisposed: {
                    print("Finish editing a todo.")
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 添加 todo 按钮事件
    @IBAction func addTodoItem(_ sender: Any) {
        let todoItem = TodoItem(name: "Todo Demo", isFinished: false)
        todoItems.value.append(todoItem)
        
        // 去除更新 UI 逻辑
        //let newRowIndex = todoItems.value.count
        //let indexPath = IndexPath(row: newRowIndex, section: 0)
        //tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func saveTodoList(_ sender: Any) {
        _ = saveTodoItems().subscribe(onNext: nil, onError: { [weak self] (error) in
            self?.flash(title: "Error", message: error.localizedDescription)
            }, onCompleted: { [weak self] in
                self?.flash(title: "Success", message: "All todos are save on your phone")
        }) {
            print("SaveOb disposed")
        }
        
        print("RC: \(RxSwift.Resources.total)")
    }
    
    @IBAction func clearTodoList(_ sender: Any) {
        todoItems.value = [TodoItem]()
        
        // 去除更新 UI 逻辑
        //tableView.reloadData()
    }
    
    @IBAction func syncToCloud(_ sender: Any) {
        // Add sync code here
        // 我们没有使用 `[weak self]`。实际上，这样完全没问题，因为 `TodoListViewController` 并不拥有 `subscribe` 返回的订阅对象。
        _ = syncTodoToCloud().subscribe(onNext: { (URL) in
            self.flash(title: "Success", message: "All todos are synced to: \(URL)")
        }, onError: { (error) in
            self.flash(title: "Failed", message: "Sync failed due to: \(error.localizedDescription)")
        }, onCompleted: nil, onDisposed: {
            print("SyncOb disposed")
        })
        
        print("RC: \(RxSwift.Resources.total)")
    }
}
