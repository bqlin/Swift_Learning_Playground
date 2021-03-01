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
    
    static let empty = WeatherData(latitude: 0, longitude: 0,
        currently: Current(time: Date(), summary: "", icon: "", temperature: 0, humidity: 0),
        daily: Week(data: []))
}
