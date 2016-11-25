//
//  CallLogACell.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/4.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class CallLogACell: UITableViewCell {

    @IBOutlet weak var headPhoto: UIImageView!
    @IBOutlet weak var callState: UIImageView!
    @IBOutlet weak var callType: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneName: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var callStartTime: UILabel!
    @IBOutlet weak var callDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
