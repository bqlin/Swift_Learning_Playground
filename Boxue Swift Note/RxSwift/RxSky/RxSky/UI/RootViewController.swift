//
//  RootViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift
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

    private let segueCurrentWeather = "SegueCurrentWeather"
    var currentWeatherViewController: CurrentWeatherViewController!

    private let segueWeekWeather = "SegueWeekWeather"
    var weekWeatherViewController: WeekWeatherViewController!

    private let segueSettings = "SegueSettings"
    private let segueLocations = "SegueLocations"

    private var bag = DisposeBag()

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
        case segueWeekWeather:
            guard let viewController = segue.destination as? WeekWeatherViewController else {
                fatalError("Invalid destination view controller!")
            }
            weekWeatherViewController = viewController
        case segueSettings:
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.topViewController as? SettingsViewController
            else {
                fatalError("Invalid destination view controller!")
            }
            viewController.delegate = self
        case segueLocations:
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.topViewController as? LocationsViewController
            else {
                fatalError("Invalid destination view controller!")
            }
            viewController.delegate = self
            viewController.currentLocation = currentLocation
        default:
            print("prepare for segue: \(segue)")
        }
    }

    // App激活时监听
    func setupActiveNotification() {
        let observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            self.requestLocation()
        }
        notificationObservers.append(observer)
    }

    func requestLocation() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func fetchCity() {
        guard let currentLocation = currentLocation else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
            guard error == nil else {
                dump(error!, name: "获取城市错误")
                return
            }

            guard let city = placemarks?.first?.locality else {
                return
            }

            // 通知 current weather view controller
            let location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel(location: location))
        }
    }

    private func fetchWeather() {
        guard let currentLocation = currentLocation else {
            return
        }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        WeatherDataManager.shared.requestWeatherDataAt(latitude: latitude, longitude: longitude).subscribe(onNext: { [weak self] data in
            guard let self = self else { return }

            self.currentWeatherViewController.weatherVM.accept(CurrentWeatherViewModel(weather: data))
            self.weekWeatherViewController.viewModel = WeekWeatherViewModel(weatherDatas: data.daily.data)
        }).disposed(by: bag)
    }

    @IBAction func unwindToRootViewController(
        segue: UIStoryboardSegue) {}
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
        performSegue(withIdentifier: segueLocations, sender: self)
    }

    func settingsButtonPressed(controller: CurrentWeatherViewController) {
        performSegue(withIdentifier: segueSettings, sender: self)
    }
}

extension RootViewController: SettingsViewControllerDelegate {
    private func reloadUI() {
        currentWeatherViewController.updateUI()
        weekWeatherViewController.updateUI()
    }

    func controllerDidChangeTimeMode(
        controller: SettingsViewController)
    {
        reloadUI()
    }

    func controllerDidChangeTemperatureMode(
        controller: SettingsViewController)
    {
        reloadUI()
    }
}

extension RootViewController: LocationsViewControllerDelegate {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }
}
