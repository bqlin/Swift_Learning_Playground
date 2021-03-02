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
    @IBOutlet var retryButton: UIButton!
    
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
        let vmCombined = Observable.combineLatest(locationVM, weatherVM) {
            ($0, $1)
        }
        .observe(on: MainScheduler.instance)
        .share(replay: 1)
        
        let vmValid = vmCombined
            .filter { location, weather in
                self.shouldDisplayWeatherContainer(locationVM: location, weatherVM: weather)
            }

        vmValid.map { $0.0.city }.bind(to: locationLabel.rx.text).disposed(by: bag)

        vmValid.map { $0.1.temperature }.bind(to: temperatureLabel.rx.text).disposed(by: bag)
        vmValid.map { $0.1.weatherIcon }.bind(to: weatherIcon.rx.image).disposed(by: bag)
        vmValid.map { $0.1.humidity }.bind(to: humidityLabel.rx.text).disposed(by: bag)
        vmValid.map { $0.1.summary }.bind(to: summaryLabel.rx.text).disposed(by: bag)
        vmValid.map { $0.1.date }.bind(to: dateLabel.rx.text).disposed(by: bag)

        vmCombined.map(shouldHideWeatherContainer)
            .bind(to: containerView.rx.isHidden).disposed(by: bag)

        vmCombined.map(shouldHideActivityIndicator)
            .bind(to: activityIndicatorView.rx.isHidden).disposed(by: bag)

        vmCombined.map(shouldAnimateActivityIndicator)
            .bind(to: activityIndicatorView.rx.isAnimating).disposed(by: bag)

        let vmInvalid = vmCombined.map(shouldDisplayErrorPrompt)

        vmInvalid.map { !$0 }.bind(to: retryButton.rx.isHidden).disposed(by: bag)
        vmInvalid.map { !$0 }.bind(to: loadingFailedLabel.rx.isHidden).disposed(by: bag)
        vmInvalid.map { _ in NSLocalizedString("Whoops! Something is wrong...", comment: "") }.bind(to: loadingFailedLabel.rx.text).disposed(by: bag)

        retryButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.weatherVM.accept(.empty)
            self.locationVM.accept(.empty)
            (self.parent as? RootViewController)?.fetchCity()
            (self.parent as? RootViewController)?.fetchWeather()
        }).disposed(by: bag)
    }
}

// 定义一些条件
private extension CurrentWeatherViewController {
    func shouldHideWeatherContainer(
        locationVM: CurrentLocationViewModel,
        weatherVM: CurrentWeatherViewModel) -> Bool
    {
        locationVM.isEmpty || locationVM.isInvalid ||
            weatherVM.isEmpty || weatherVM.isInvalid
    }
    
    func shouldHideActivityIndicator(
        locationVM: CurrentLocationViewModel,
        weatherVM: CurrentWeatherViewModel) -> Bool
    {
        (!locationVM.isEmpty && !weatherVM.isEmpty) ||
            locationVM.isInvalid || weatherVM.isInvalid
    }
    
    func shouldAnimateActivityIndicator(
        locationVM: CurrentLocationViewModel,
        weatherVM: CurrentWeatherViewModel) -> Bool
    {
        locationVM.isEmpty || weatherVM.isEmpty
    }
    
    func shouldDisplayErrorPrompt(
        locationVM: CurrentLocationViewModel,
        weatherVM: CurrentWeatherViewModel) -> Bool
    {
        locationVM.isInvalid || weatherVM.isInvalid
    }
    
    func shouldDisplayWeatherContainer(
        locationVM: CurrentLocationViewModel,
        weatherVM: CurrentWeatherViewModel) -> Bool
    {
        !locationVM.isEmpty && !locationVM.isInvalid &&
            !weatherVM.isEmpty && !weatherVM.isInvalid
    }
}
