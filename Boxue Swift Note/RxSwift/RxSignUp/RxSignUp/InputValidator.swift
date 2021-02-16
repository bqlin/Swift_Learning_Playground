//
//  InputValidator.swift
//  RxLogin
//
//  Created by Bq Lin on 2021/2/5.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

class InputValidator {
    class func isValidEmail(_ email: String) -> Bool {
        var valid = true
        
        // 正则匹配邮箱格式
        guard let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$", options: .caseInsensitive) else { return false }
        let range = NSRange(location: 0, length: email.lengthOfBytes(using: .utf8))
        let result = re.matches(in: email, options: .reportProgress, range: range)
        valid &&= result.count > 0
        
        //print("\"\(email)\" is \(valid ? "valid" : "invalid")")

        return valid
    }

    class func isValidPassword(_ password: String) -> Bool {
        var valid = true
        
        // 长度限制
        valid &&= password.count >= 8
        
        //print("\"\(password)\" is \(valid ? "valid" : "invalid")")

        return valid
    }
    
    class func isValidDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let compare = calendar.compare(date, to: Date(), toGranularity: .day)
        return compare == .orderedAscending
    }
}
