//
//  WeekWeatherViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/25.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension WeekWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
