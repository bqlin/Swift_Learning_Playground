//
//  FormatUtil.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation

class FormatUtil {
    static let percentNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        
        return formatter
    }()
    
    static let weekMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM"
        
        return formatter
    }()
    
    static let weekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter
    }()
    
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        
        return formatter
    }()
    
    class func temperature(_ temperature: Double) -> String {
        return String(format: "%.1f °C", temperature.toCelcius())
    }
    
    class func humidity(_ humidity: Any) -> String {
        return percentNumberFormatter.string(for: humidity)!
    }
    
    class func weekDate(_ time: Date) -> String {
        return weekMonthFormatter.string(from: time)
    }
    
    class func week(_ time: Date) -> String {
        return weekFormatter.string(from: time)
    }
    
    class func date(_ time: Date) -> String {
        return monthFormatter.string(from: time)
    }
}
