//
//  WeekWeatherViewModel.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

struct WeekWeatherViewModel {
    let weatherDatas: [ForecastData]

    var numberOfSections: Int {
        1
    }

    var numberOfDays: Int {
        weatherDatas.count
    }

    func viewModel(for index: Int) -> WeekWeatherViewModel.Day {
        WeekWeatherViewModel.Day(weatherData: weatherDatas[index])
    }
}

protocol WeekWeatherDayRepresentable {
    var week: String { get }
    var date: String { get }
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var humidity: String { get }
}

extension WeekWeatherViewModel {
    struct Day: WeekWeatherDayRepresentable {
        let weatherData: ForecastData

        var week: String {
            FormatUtil.week(weatherData.time)
        }

        var date: String {
            FormatUtil.date(weatherData.time)
        }

        var temperature: String {
            "\(FormatUtil.temperature(weatherData.temperatureLow)) - \(FormatUtil.temperature(weatherData.temperatureHigh))"
        }

        var weatherIcon: UIImage? {
            UIImage.weatherIcon(of: weatherData.icon)
        }

        var humidity: String {
            FormatUtil.humidity(weatherData.humidity)
        }
    }
}
