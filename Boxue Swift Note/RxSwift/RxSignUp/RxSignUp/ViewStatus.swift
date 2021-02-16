//
//  ViewStatus.swift
//  RxSignUp
//
//  Created by Bq Lin on 2021/2/16.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

let borderColor = { (valid: Bool) -> UIColor in
    let color: UIColor = valid ? .green : .clear
    
    return color
}

func initialSetup(view: UIView!) {
    view.layer.borderWidth = 1
    view.layer.cornerRadius = 4
}

func setupBorderColor(view: UIView!, color: UIColor) {
    view.layer.borderColor = color.cgColor
}
