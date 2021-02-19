//
//  RepositoryInfoTableViewCell.swift
//  RxGitHubSearch
//
//  Created by Bq Lin on 2021/2/19.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

class RepositoryInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
