//
//  Configuratioin.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

struct API {
    static let key: String = {
        let path = Bundle.main.path(forResource: "secret-key", ofType: nil)!
        var secretKey = try! String(contentsOfFile: path)
        secretKey = secretKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return secretKey
    }()
    
    static let baseURL = URL(string: "https://api.darksky.net/forecast/")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}
