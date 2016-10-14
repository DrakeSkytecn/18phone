//
//  LoginCell.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/28.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class LoginCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
