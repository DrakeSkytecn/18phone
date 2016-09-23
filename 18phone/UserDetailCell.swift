//
//  UserDetailCell.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell {

    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sexImage: UIImageView!
    
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
