//
//  DetailLogCell.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class DetailLogCell: UITableViewCell {

    @IBOutlet weak var callState: UIImageView!
    
    @IBOutlet weak var callType: UIImageView!
    
    @IBOutlet weak var callStartTime: UILabel!
    
    @IBOutlet weak var callDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
