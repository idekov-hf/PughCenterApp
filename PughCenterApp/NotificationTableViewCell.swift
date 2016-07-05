//
//  NotificationTableViewCell.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 7/4/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1.0)
        containerView.layer.cornerRadius = 20.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
