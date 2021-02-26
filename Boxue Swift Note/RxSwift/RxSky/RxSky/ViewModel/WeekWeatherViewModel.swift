//
//  WeekWeatherViewModel.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherData: [ForecastData]
    
    func week(for index: Int) -> String {
        FormatUtil.week(weatherData[index].time)
    }
    func month(for index: Int) -> String {
        FormatUtil.date(weatherData[index].time)
    }
    func temperature(for index: Int) -> String {
        "\(FormatUtil.temperature(weatherData[index].temperatureLow)) - \(FormatUtil.temperature(weatherData[index].temperatureHigh))"
    }
    func weatherIcon(for index: Int) -> UIImage? {
        UIImage.weatherIcon(of: weatherData[index].icon)
    }
    func humidity(for index: Int) -> String {
        FormatUtil.humidity(weatherData[index].humidity)
    }
    
    var numberOfSections: Int {
        return 1
    }
    var numberOfDays: Int {
        return weatherData.count
    }
}
