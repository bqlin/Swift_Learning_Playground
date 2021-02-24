//
//  CurrentWeatherViewModel.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/24.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

struct CurrentWeatherViewModel {
    // MARK: model

    var location: Location! {
        didSet {
            if location != nil {
                isLocationReady = true
            }
            else {
                isLocationReady = false
            }
        }
    }

    var weather: WeatherData! {
        didSet {
            if weather != nil {
                isWeatherReady = true
            }
            else {
                isWeatherReady = false
            }
        }
    }

    // MARK: 数据转换

    // 这里对于可以通过属性获取的值就没有多此一举地在这里添加属性

    var isLocationReady = false
    var isWeatherReady = false
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }

    var temperature: String {
        String(
            format: "%.1f °C",
            weather.currently.temperature.toCelcius())
    }

    var humidity: String {
        let percentNumberFormatter = NumberFormatter()
        percentNumberFormatter.numberStyle = .percent
        percentNumberFormatter.maximumFractionDigits = 1
        percentNumberFormatter.minimumFractionDigits = 0
        return percentNumberFormatter.string(from: weather.currently.humidity as NSNumber)!
    }

    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        return formatter.string(from: weather.currently.time)
    }
}
