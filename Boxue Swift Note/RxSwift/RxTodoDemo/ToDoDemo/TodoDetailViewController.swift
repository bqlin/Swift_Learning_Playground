//
// Created by Bq on 2020/1/20.
// Copyright (c) 2020 Mars. All rights reserved.
//

import UIKit
import RxSwift

class TodoDetailViewController: UITableViewController {
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var isFinished: UISwitch!
    @IBOutlet weak var doneBarBtn: UIBarButtonItem!
    
    // 内部使用
    fileprivate let todoSubject = PublishSubject<TodoItem>()
    // 外部使用
    var todo: Observable<TodoItem> {
        return todoSubject.asObservable()
    }
    var todoItem: TodoItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoName.becomeFirstResponder()
        
        if let todoItem = todoItem { // 修改
            self.todoName.text = todoItem.name
            self.isFinished.isOn = todoItem.isFinished
        } else { // 创建
            todoItem = TodoItem()
        }
        
        print("Resource tracing: \(RxSwift.Resources.total)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        todoSubject.onCompleted()
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        // 通知 todoSubject
        todoItem.name = todoName.text!
        todoItem.isFinished = isFinished.isOn
        todoSubject.onNext(todoItem)
        
        dismiss(animated: true, completion: nil)
    }
}

extension TodoDetailViewController {
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension TodoDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarBtn.isEnabled = newText.length > 0
        
        return true
    }
}
