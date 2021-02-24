//
//  RootViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import CoreLocation
import UIKit

class RootViewController: UIViewController {
    var notificationObservers: [NSObjectProtocol] = []

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000

        return manager
    }()

    private var currentLocation: CLLocation? {
        didSet {
            // 请求城市名称
            fetchCity()
            // 请求天气数据
            fetchWeather()
        }
    }

    var currentWeatherViewController: CurrentWeatherViewController!
    private let segueCurrentWeather = "SegueCurrentWeather"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupActiveNotification()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case segueCurrentWeather:
                guard let viewController = segue.destination as? CurrentWeatherViewController else {
                    fatalError("Invalid destination view controller!")
                }
                currentWeatherViewController = viewController
                currentWeatherViewController.delegate = self
            default:
                print("prepare for segue: \(segue)")
        }
    }

    // App激活时监听
    func setupActiveNotification() {
        let observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            self.requestLocaiton()
        }
        notificationObservers.append(observer)
    }

    func requestLocaiton() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                locationManager.requestLocation()
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }

    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
            guard error == nil else {
                dump(error!, name: "获取城市错误")
                return
            }

            guard let city = placemarks?.first?.locality else { return }

            // 通知 current weather view controller
            self.currentWeatherViewController.location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
    }

    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        WeatherDataManager.shared.requestWeatherDataAt(latitude: latitude, longitude: longitude) { response, error in
            guard error == nil else {
                dump(error, name: "天气请求错误")
                return
            }

            guard let response = response else { return }
            // 通知 current weather view controller
            self.currentWeatherViewController.nowWeather = response
        }
    }
}

extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                manager.requestLocation()
            default:
                break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
}

extension RootViewController: CurrentWeatherViewControllerDelegate {
    func locationButtonPressed(controller: CurrentWeatherViewController) {
        print("Open locations.")
    }
    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        print("Open Settings")
    }
}
