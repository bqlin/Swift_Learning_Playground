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
    @IBOutlet var weatherContainerView: UIView!
    @IBOutlet var loadingFailedLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

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
