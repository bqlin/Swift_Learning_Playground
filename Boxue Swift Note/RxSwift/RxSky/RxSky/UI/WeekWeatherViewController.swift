//
//  WeekWeatherViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/25.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {
    @IBOutlet var tableView: UITableView!

    var viewModel: WeekWeatherViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }

    func updateUI() {
        activityIndicatorView.stopAnimating()
        guard viewModel != nil else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Load Location/Weather failed!"
            return
        }

        containerView.isHidden = false
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WeekWeatherViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfDays ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeekWeatherTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        if let vm = viewModel {
            let index = indexPath.row
            cell.week.text = vm.week(for: index)
            cell.date.text = vm.month(for: index)
            cell.temperature.text = vm.temperature(for: index)
            cell.weatherIcon.image = vm.weatherIcon(for: index)
            cell.humidity.text = vm.humidity(for: index)
        }

        return cell
    }
}
