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

    var weather: WeatherData
}

extension CurrentWeatherViewModel {
    static let empty = CurrentWeatherViewModel(weather: .empty)
    var isEmpty: Bool {
        weather.isEmpty
    }
    
    static let invalid = CurrentWeatherViewModel(weather: .invalid)
    var isInvalid: Bool {
        weather.isInvalid
    }
    
    var isEmptyOrInvalid: Bool {
        isEmpty || isInvalid
    }
}

// MARK: 数据转换

extension CurrentWeatherViewModel {
    var temperature: String {
        FormatUtil.temperature(weather.currently.temperature)
    }

    var humidity: String {
        FormatUtil.humidity(weather.currently.humidity)
    }

    var date: String {
        FormatUtil.weekDate(weather.currently.time)
    }

    var weatherIcon: UIImage {
        .weatherIcon(of: weather.currently.icon)!
    }

    var summary: String {
        weather.currently.summary
    }
}
