//
// Created by Bq Lin on 2021/2/26.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

class SettingsViewModel {
    static let sections: [SettingsRepresentable.Type] = [Date.self, Temperature.self]
}

protocol SettingsRepresentable {
    static var name: String { get }
    static var count: Int { get }

    var labelText: String { get }
    var accessory: UITableViewCell.AccessoryType { get }
}

extension SettingsViewModel {
    struct Date: SettingsRepresentable {
        static let name = "Date format"
        static let count = DateMode.allCases.count

        let dateMode: DateMode
        var labelText: String {
            switch dateMode {
                case .text:
                    return "Fri, 01 December"
                case .digit:
                    return "F, 12/01"
            }
        }

        var accessory: UITableViewCell.AccessoryType {
            UserDefaults.dateMode == dateMode ? .checkmark : .none
        }
    }

    struct Temperature: SettingsRepresentable {
        static let name = "Temperature unit"
        static let count = TemperatureMode.allCases.count

        let temperatureMode: TemperatureMode
        var labelText: String {
            switch temperatureMode {
                case .celsius:
                    return "Celsius"
                case .fahrenheit:
                    return "Fahrenheit"
            }
        }

        var accessory: UITableViewCell.AccessoryType {
            UserDefaults.temperatureMode == temperatureMode ? .checkmark : .none
        }
    }
}
