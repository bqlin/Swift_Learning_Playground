//
// Created by Bq Lin on 2021/2/27.
// Copyright (c) 2021 Bq. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell, ReusableCellProtocol {
    static let reuseIdentifier = "LocationCell"
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with viewModel: LocationRepresentable) {
        label.text = viewModel.labelText
    }
}
