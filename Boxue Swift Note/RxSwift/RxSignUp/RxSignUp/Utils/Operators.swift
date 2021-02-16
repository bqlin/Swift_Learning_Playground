//
//  OperatorExtension.swift
//  RxLogin
//
//  Created by Bq Lin on 2021/2/6.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

infix operator ||=: AssignmentPrecedence
func ||= (lhs: inout Bool, rhs: Bool) {
    lhs = lhs || rhs
}

infix operator &&=: AssignmentPrecedence
func &&= (lhs: inout Bool, rhs: Bool) {
    lhs = lhs && rhs
}
