//
//  TodoListViewAlert.swift
//  ToDoDemo
//
//  Created by Bq on 2020/1/20.
//  Copyright © 2020 Mars. All rights reserved.
//

import UIKit

extension TodoListViewController {
    func flash(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
