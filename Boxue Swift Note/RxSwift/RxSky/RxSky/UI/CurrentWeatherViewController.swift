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
        let vmObserable = Observable.combineLatest(locationVM, weatherVM) {
                ($0, $1)
            }
            .filter { location, weather in
                !location.isEmpty && !weather.isEmpty
            }
            .share(replay: 1)
            .observe(on: MainScheduler.instance)
        
        vmObserable.map { _ in
            false
        }.bind(to: activityIndicatorView.rx.isAnimating).disposed(by: bag)
        vmObserable.map { _ in
            false
        }.bind(to: containerView.rx.isHidden).disposed(by: bag)
        
        vmObserable.map { $0.0.city }.bind(to: self.locationLabel.rx.text).disposed(by: bag)
        
        vmObserable.map { $0.1.temperature }.bind(to: self.temperatureLabel.rx.text).disposed(by: bag)
        vmObserable.map { $0.1.weatherIcon }.bind(to: self.weatherIcon.rx.image).disposed(by: bag)
        vmObserable.map { $0.1.humidity }.bind(to: self.humidityLabel.rx.text).disposed(by: bag)
        vmObserable.map { $0.1.summary }.bind(to: self.summaryLabel.rx.text).disposed(by: bag)
        vmObserable.map { $0.1.date }.bind(to: self.dateLabel.rx.text).disposed(by: bag)
    
        // .subscribe(onNext: { [weak self] location, weather in
        //     guard let self = self else {
        //         return
        //     }
        //
        //     self.activityIndicatorView.stopAnimating()
        //     self.containerView.isHidden = false
        //
        //     self.locationLabel.text = location.location.name
        //
        //     self.temperatureLabel.text = weather.temperature
        //     self.weatherIcon.image = weather.weatherIcon
        //     self.humidityLabel.text = weather.humidity
        //     self.summaryLabel.text = weather.summary
        //     self.dateLabel.text = weather.date
        // }).disposed(by: bag)
    }
}
