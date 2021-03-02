//
// Created by Bq Lin on 2021/3/1.
// Copyright (c) 2021 Bq. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

// 实现具有delegate属性的类型说明
extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

// 定义具体的proxy
class CLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: CLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register {
            CLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

// 定义Rx扩展
extension Reactive where Base: CLLocationManager {
    var delegate: CLLocationManagerDelegateProxy {
        CLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        let sel = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return delegate.methodInvoked(sel).map {
            $0[1] as! [CLLocation]
        }
    }
}
