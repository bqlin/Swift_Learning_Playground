//
//  WeatherDataManager.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}

// 封装数据请求逻辑
final class WeatherDataManager {
    private let baseURL: URL
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    static let shared = WeatherDataManager(baseURL: API.authenticatedURL)
    
    func requestWeatherDataAt(latitude: Double, longitude: Double) -> Observable<WeatherData> {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        return URLSession.shared.rx.data(request: request).map { data in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            
            return weatherData
        }
    }
}
