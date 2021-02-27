//
//  Location.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable, Equatable {
    var name: String
    var latitude: Double
    var longitude: Double
}

extension Location {
    static let userDefaultsKey = "locations"
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension UserDefaults {
    static var locations: [Location] {
        set {
            let data: Data
            do {
                data = try JSONEncoder().encode(newValue)
            } catch {
                fatalError("\(error)")
            }

            UserDefaults.standard.set(data, forKey: Location.userDefaultsKey)
        }
        get {
            guard let data: Data = UserDefaults.standard.data(forKey: Location.userDefaultsKey) else {
                return []
            }
            let result: [Location]
            do {
                result = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                fatalError("\(error)")
            }

            return result
        }
    }

    static func addLocation(_ location: Location) {
        var locations = self.locations
        locations.append(location)
        self.locations = locations
    }

    static func removeLocation(_ location: Location) {
        var locations = self.locations
        guard let index = locations.firstIndex(of: location) else {
            return
        }
        locations.remove(at: index)
        self.locations = locations
    }
}
