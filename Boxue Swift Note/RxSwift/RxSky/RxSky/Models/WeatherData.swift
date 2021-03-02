//
//  WeatherData.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

struct WeatherData: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    
    let currently: Current
    
    struct Current: Codable, Equatable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
    
    let daily: Week
    
    struct Week: Codable, Equatable {
        let data: [ForecastData]
    }
}

extension WeatherData {
    // 空语义
    static let empty = WeatherData(
        latitude: 0, longitude: 0,
        currently: Current(time: Date(timeIntervalSince1970: 0), summary: "", icon: "", temperature: 0, humidity: 0),
        daily: Week(data: []))
    
    // 错误语义
    static let invalid = WeatherData(
        latitude: 0,
        longitude: 0,
        currently: Current(
            time: Date(timeIntervalSince1970: 0),
            summary: "n/a", icon: "n/a",
            temperature: -274, humidity: -1),
        daily: Week(data: []))
    
    var isEmpty: Bool {
        self == .empty
    }
    
    var isInvalid: Bool {
        self == .invalid
    }
}
