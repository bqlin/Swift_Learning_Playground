//
//  CurrentWeatherViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/24.
//  Copyright © 2021 Bq. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol CurrentWeatherViewControllerDelegate: class {
    func locationButtonPressed(controller: CurrentWeatherViewController)
    func settingsButtonPressed(controller: CurrentWeatherViewController)
}

/// 上半部分展示当前天气的view controller
class CurrentWeatherViewController: WeatherViewController {
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var humidityLabel: UILabel! // 湿度
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    weak var delegate: CurrentWeatherViewControllerDelegate?

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        delegate?.locationButtonPressed(controller: self)
    }

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        delegate?.settingsButtonPressed(controller: self)
    }

    private var bag = DisposeBag()

    var weatherVM = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM = BehaviorRelay(value: CurrentLocationViewModel.empty)

    func updateUI() {
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Observable.combineLatest(locationVM, weatherVM) {
            ($0, $1)
        }.filter { location, weather in
            !location.isEmpty && !weather.isEmpty
        }.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] location, weather in
            guard let self = self else { return }

            self.activityIndicatorView.stopAnimating()
            self.containerView.isHidden = false

            self.locationLabel.text = location.location.name

            self.temperatureLabel.text = weather.temperature
            self.weatherIcon.image = weather.weatherIcon
            self.humidityLabel.text = weather.humidity
            self.summaryLabel.text = weather.summary
            self.dateLabel.text = weather.date
        }).disposed(by: bag)
    }
}
