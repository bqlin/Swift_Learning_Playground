//
// Created by Bq Lin on 2021/3/1.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location

    static let empty = CurrentLocationViewModel(location: .empty)
}

extension CurrentLocationViewModel {
    var city: String {
        location.name
    }

    var isEmpty: Bool {
        location == .empty
    }
}
