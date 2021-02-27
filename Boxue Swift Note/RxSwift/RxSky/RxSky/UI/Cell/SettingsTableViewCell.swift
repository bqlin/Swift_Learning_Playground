//
//  SettingsTableViewCell.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, ReusableCellProtocol {
    static let reuseIdentifier = "SettingsTableViewCell"
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // 通过protocol自行配置，这时其实可以完全隐藏自身的UI属性，不向外部暴露
    func configure(with vm: SettingViewModelProtocol) {
        label.text = vm.labelText
        accessoryType = vm.accessory
    }
}
