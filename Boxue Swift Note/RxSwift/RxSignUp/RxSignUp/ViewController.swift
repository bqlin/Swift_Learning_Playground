//
//  ViewController.swift
//  RxLogin
//
//  Created by Bq Lin on 2021/2/5.
//  Copyright © 2021 Bq. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var register: UIButton!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        email.layer.borderWidth = 1
        email.layer.cornerRadius = 4

        let emailObservable = email.rx.text.orEmpty.map {
            InputValidator.isValidEmail($0)
        }

        emailObservable.map { (valid) -> UIColor in
            let color: UIColor = valid ? .green : .clear

            return color
        }.subscribe(onNext: { [weak self] in // !!!: 注意这里要弱引用 self
            guard let self = self else { return }

            self.email.layer.borderColor = $0.cgColor
        }).disposed(by: bag)

        let passwordObservale = password.rx.text.orEmpty.map {
            InputValidator.isValidPassword($0)
        }

        // 优化后的流程

        initialSetup(view: password)
        password.autocorrectionType = .no // 防止 [AutoFill] Cannot show Automatic Strong Passwords for app bundleID
        passwordObservale.map(borderColor).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            setupBorderColor(view: self.password, color: $0)
        }).disposed(by: bag)

        // 设置注册按钮
        Observable.combineLatest(emailObservable, passwordObservale) { $0 && $1 }
            .bind(to: register.rx.isEnabled)
            .disposed(by: bag)
    }

    deinit {
        print("\(#function) in \(type(of: self))")
    }
}
