//
// Created by Bq Lin on 2021/2/28.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    private lazy var geocoder = CLGeocoder()
    
    private var isQuerying = false {
        didSet {
            queryingStatusDidChange?(isQuerying)
        }
    }
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    // 回调
    var queryingStatusDidChange: ((Bool) -> Void)?
    var locationsDidChange: (([Location]) -> Void)?
    
    private func geocode(address: String?) {
        guard let address = address, !address.isEmpty else {
            locations = []
            return
        }
        isQuerying = true
        geocoder.geocodeAddressString(address) {
            [weak self] (placemarks, error) in
            self?.processResponse(with: placemarks, error: error)
        }
    }
    
    private func processResponse(with placemarks: [CLPlacemark]?, error: Error?) {
        isQuerying = false
        var locations: [Location] = []
        if let error = error {
            print("Cannot handle Geocode Address! \(error)")
        } else if let placemarks = placemarks {
            locations = placemarks.compactMap {
                guard let name = $0.name else {
                    return nil
                }
                guard let location = $0.location else {
                    return nil
                }
                
                return Location(name: name,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
            }
            self.locations = locations
        }
    }
}

extension AddLocationViewModel {
    var numberOfLocations: Int {
        return locations.count
    }
    
    var hasLocationsResult: Bool {
        return numberOfLocations > 0
    }
    
    func location(at index: Int) -> Location? {
        guard index < numberOfLocations, index >= 0 else {
            return nil
        }
        
        return locations[index]
    }
    
    func locationViewModel(at index: Int) -> LocationRepresentable? {
        guard let location = location(at: index) else {
            return nil
        }
        
        return LocationsViewModel(location: location.location, locationText: location.name)
    }
}
