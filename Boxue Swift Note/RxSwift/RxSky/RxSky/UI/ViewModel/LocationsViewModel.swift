//
// Created by Bq Lin on 2021/2/27.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationsViewModel {
    let location: CLLocation?
    let locationText: String?
}

protocol LocationRepresentable {
    var labelText: String { get }
}

extension LocationsViewModel: LocationRepresentable {
    var labelText: String {
        if let locationText = locationText {
            return locationText
        }
        else if let location = location {
            return location.toString
        }
        return "Unknown position"
    }
}