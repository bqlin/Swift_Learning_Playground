//
//  FormatUtil.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

class FormatUtil {
    private static let percentNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    private static let weekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        return formatter
    }()

    private static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"

        return formatter
    }()

    class func temperature(_ temperature: Double, mode: TemperatureMode = UserDefaults.temperatureMode) -> String {
        var format = ""
        var value = temperature
        switch mode {
        case .celsius:
            format = "%.1f °C"
            value = temperature.toCelcius()
        case .fahrenheit:
            format = "%.1f °F"
            value = temperature
        }
        return String(format: format, value)
    }

    class func humidity(_ humidity: Any) -> String {
        return percentNumberFormatter.string(for: humidity)!
    }

    class func weekDate(_ time: Date, mode: DateMode = UserDefaults.dateMode) -> String {
        weekDateFormatter.dateFormat = mode.format
        return weekDateFormatter.string(from: time)
    }

    class func week(_ time: Date) -> String {
        return weekFormatter.string(from: time)
    }

    class func date(_ time: Date) -> String {
        return dateFormatter.string(from: time)
    }
}
