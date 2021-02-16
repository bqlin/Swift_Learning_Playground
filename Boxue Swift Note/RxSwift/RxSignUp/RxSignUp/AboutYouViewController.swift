//
//  AboutYouViewController.swift
//  RxSignUp
//
//  Created by Bq Lin on 2021/2/16.
//  Copyright © 2021 Bq. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AboutYouViewController: UIViewController {
    @IBOutlet var birthday: UIDatePicker!
    @IBOutlet var male: UIButton!
    @IBOutlet var female: UIButton!
    @IBOutlet var knowSwift: UISwitch!
    @IBOutlet var swiftLevel: UISlider!
    @IBOutlet var passionToLearn: UIStepper!
    @IBOutlet var heartHeight: NSLayoutConstraint!
    @IBOutlet var update: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    enum Gender {
        case notSelected
        case male
        case female
    }

    let genderSelection = BehaviorRelay<Gender>(value: .notSelected)

    override func viewDidLoad() {
        super.viewDidLoad()

        let birthdayObserable = birthday.rx.date.map {
            InputValidator.isValidDate($0)
        }
        
        initialSetup(view: birthday)
        birthdayObserable.map(borderColor).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            setupBorderColor(view: self.birthday, color: $0)
        }).disposed(by: bag)
        
        // 点击male修改genderSelection状态
        male.rx.tap.map { Gender.male }
            .bind(to: genderSelection)
            .disposed(by: bag)
        female.rx.tap.map { Gender.female }
            .bind(to: genderSelection)
            .disposed(by: bag)
        
        // 同步genderSelection状态到UI
        genderSelection.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.female.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.male.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            switch $0 {
                case .male:
                    self.male.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                case .female:
                    self.female.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                default:
                    print("gender default")
            }
        }).disposed(by: bag)
        
        // 创建性别合法校验
        let genderObservable = genderSelection.map { $0 != .notSelected }
        
        // 汇总校验，并绑定到update按钮
        Observable.combineLatest(birthdayObserable, genderObservable) { $0 && $1 }
            .bind(to: update.rx.isEnabled)
            .disposed(by: bag)
        
        /*:
         处理 UISwitch 和 UISlider 联动。
         对于 UISwitch 来说：
         1. 当 UISwitch 为OFF时，表示用户不了解Swift，因此，下面的 UISlider 应该为0；
         2. 当 UISwitch 为ON时，可以默认把 UISlider 设置在1/4的位置，表示大致了解；
         对于 UISlider 来说：
         1. 当 UISlider 不为0时，应该自动把 UISwitch 设置为ON；
         2. 当 UISlider 为0时，应该自动把 UISwitch 设置为OFF；
         */
        knowSwift.rx.value.map { $0 ? 0.25 : 0 }
            .bind(to: swiftLevel.rx.value)
            .disposed(by: bag)
        swiftLevel.rx.value.map { $0 != 0 }
            .bind(to: knowSwift.rx.value)
            .disposed(by: bag)
    }
    
    deinit {
        print("\(#function) in \(type(of: self))")
    }
}
