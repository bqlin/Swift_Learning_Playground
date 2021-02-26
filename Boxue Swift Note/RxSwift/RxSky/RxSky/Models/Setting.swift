//
//  Setting.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

enum DateMode: Int, CaseIterable {
    case text
    case digit
    var format: String {
        switch self {
        case .text:
            return "E, dd MMMM"
        case .digit:
            return "EEEEE, MM/dd"
        }
    }
}

enum TemperatureMode: Int, CaseIterable {
    case celsius
    case fahrenheit
}

struct SettingUserDefaultsKeys {
    static let dateMode = "dateMode"
    static let temperatureMode = "temperatureMode"
}

extension UserDefaults {
    static var dateMode: DateMode {
        get {
            let value = UserDefaults.standard.integer(forKey: SettingUserDefaultsKeys.dateMode)
            return DateMode(rawValue: value) ?? .text
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: SettingUserDefaultsKeys.dateMode)
        }
    }

    static var temperatureMode: TemperatureMode {
        get {
            let value = UserDefaults.standard.integer(forKey: SettingUserDefaultsKeys.temperatureMode)
            return TemperatureMode(rawValue: value) ?? .celsius
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: SettingUserDefaultsKeys.temperatureMode)
        }
    }
}
