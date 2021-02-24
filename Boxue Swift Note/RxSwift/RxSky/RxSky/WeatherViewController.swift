//
//  WeatherViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/24.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

/// 上下两部分的基类，处理了两个view controller的公共基础设施
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherContainerView: UIView!
    @IBOutlet weak var loadingFailedLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func weatherIcon(of name: String) -> UIImage? {
        switch name {
            case "clear-day":
                return UIImage(named: "clear-day")
            case "clear-night":
                return UIImage(named: "clear-night")
            case "rain":
                return UIImage(named: "rain")
            case "snow":
                return UIImage(named: "snow")
            case "sleet":
                return UIImage(named: "sleet")
            case "wind":
                return UIImage(named: "wind")
            case "cloudy":
                return UIImage(named: "cloudy")
            case "partly-cloudy-day":
                return UIImage(named: "partly-cloudy-day")
            case "partly-cloudy-night":
                return UIImage(named: "partly-cloudy-night")
            default:
                return UIImage(named: "clear-day")
        }
    }
    
    private func setupUI() {
        weatherContainerView.isHidden = true
        loadingFailedLabel.isHidden = true
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
