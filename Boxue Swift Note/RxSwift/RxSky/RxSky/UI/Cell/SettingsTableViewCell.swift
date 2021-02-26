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
}
