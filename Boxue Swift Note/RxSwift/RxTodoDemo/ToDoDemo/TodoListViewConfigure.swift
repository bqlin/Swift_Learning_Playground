//
//  TodoListViewConfigure.swift
//  TodoDemo
//
//  Created by Mars on 24/04/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import UIKit
import RxSwift

let CELL_CHECKMARK_TAG = 1001
let CELL_TODO_TITLE_TAG = 1002

enum SaveTodoError: Error {
    case cannotSaveToLocalFile
    case iCloudIsNotEnabled
    case cannotReadLocalFile
    case cannotCreateFileOnCloud
}

extension TodoListViewController {
    /// 配置 todo 完成状态
    func configureStatus(for cell: UITableViewCell, with item: TodoItem) {
        let label = cell.viewWithTag(CELL_CHECKMARK_TAG) as! UILabel
        
        if item.isFinished {
            label.text = "✓"
        }
        else {
            label.text = ""
        }
    }
    
    /// 配置标题
    func configureLabel(for cell: UITableViewCell, with item: TodoItem) {
        let label = cell.viewWithTag(CELL_TODO_TITLE_TAG) as! UILabel
        
        label.text = item.name
    }
    
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("TodoList.plist")
    }
    
    func ubiquityURL(_ filename: String) -> URL? {
        let ubiquityURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        
        if let ubiquityURL = ubiquityURL {
            return ubiquityURL.appendingPathComponent(filename)
        }
        
        return nil
    }
    
    /// 同步到 iCloud
    func syncTodoToCloud() -> Observable<URL> {
        // 改造
        return Observable.create({ (observer) -> Disposable in
            guard let cloudUrl =  self.ubiquityURL("Documents/TodoList.plist") else {
                //self.flash(title: "Failed", message: "You should enabled iCloud in Settings first.")
                observer.onError(SaveTodoError.iCloudIsNotEnabled)
                return Disposables.create()
            }
            
            guard let localData = NSData(contentsOf: self.dataFilePath()) else {
                //self.flash(title: "Failed", message: "Cannot read local file.")
                observer.onError(SaveTodoError.cannotReadLocalFile)
                return Disposables.create()
            }
            
            let plist = PlistDocument(fileURL: cloudUrl, data: localData)
            
            plist.save(to: cloudUrl, for: .forOverwriting) { (success) in
                print(cloudUrl)
                
                if success {
                    observer.onNext(cloudUrl)
                    observer.onCompleted()
                    //self.flash(title: "Success", message: "All todos are synced to cloud.")
                } else {
                    observer.onError(SaveTodoError.cannotCreateFileOnCloud)
                    //self.flash(title: "Failed", message: "Sync todos to cloud failed")
                }
            }
            
            return Disposables.create()
        })
    }
    
    // 保存模型
    func saveTodoItems() -> Observable<Void> {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(todoItems.value, forKey: "TodoItems")
        archiver.finishEncoding()
        
        // 处理写入失败的情况
        return Observable.create({ (observer) -> Disposable in
            let result = data.write(to: self.dataFilePath(), atomically: true)
            if !result {
                observer.onError(SaveTodoError.cannotSaveToLocalFile)
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
        // 这里的闭包不需要 weak self
    }
    
    // 载入模型
    func loadTodoItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            todoItems.value = unarchiver.decodeObject(forKey: "TodoItems") as! [TodoItem]
            
            unarchiver.finishDecoding()
        }
    }
}
