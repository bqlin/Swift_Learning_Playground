//
//  WeekWeatherTableViewCell.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/25.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: UITableViewCell, ReusableCellProtocol {
    static let reuseIdentifier = "WeekWeatherCell"
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with vm: WeekWeatherDayRepresentable) {
        week.text = vm.week
        date.text = vm.date
        humidity.text = vm.humidity
        temperature.text = vm.temperature
        weatherIcon.image = vm.weatherIcon
    }
}
