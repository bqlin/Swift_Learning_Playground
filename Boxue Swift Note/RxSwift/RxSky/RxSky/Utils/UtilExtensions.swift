//
//  UtilExtensions.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/24.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

extension Double {
    func toCelsius() -> Double {
        return (self - 32.0) / 1.8
    }
}

extension UIImage {
    class func weatherIcon(of name: String) -> UIImage? {
        switch name {
            case "clear-day":
                return UIImage(named: "clear-day")
            case "clear-night":
                return UIImage(named: "clear-night")
            case "rain":
                return UIImage(named: "rain")
            case "snow":
                return UIImage(named: "snow")
            case "sleet":
                return UIImage(named: "sleet")
            case "wind":
                return UIImage(named: "wind")
            case "cloudy":
                return UIImage(named: "cloudy")
            case "partly-cloudy-day":
                return UIImage(named: "partly-cloudy-day")
            case "partly-cloudy-night":
                return UIImage(named: "partly-cloudy-night")
            default:
                return UIImage(named: "clear-day")
        }
    }
}

import CoreLocation
extension CLLocation {
    var toString: String {
        let latitude = String(format: "%.3f", coordinate.latitude)
        let longitude = String(format: "%.3f", coordinate.longitude)
        return "\(latitude), \(longitude)"
    }
}