//
// Created by Bq Lin on 2021/3/1.
// Copyright (c) 2021 Bq. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    var location: Location

}

extension CurrentLocationViewModel {
    var city: String {
        location.name
    }

    static let empty = CurrentLocationViewModel(location: .empty)
    var isEmpty: Bool {
        location.isEmpty
    }
    
    static let invalid = CurrentLocationViewModel(location: .invalid)
    var isInvalid: Bool {
        location.isInvalid
    }
    
    var isEmptyOrInvalid: Bool {
        isEmpty || isInvalid
    }
}
