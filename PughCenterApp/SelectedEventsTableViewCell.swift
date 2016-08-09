//
//  SelectedEventsTableViewCell.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/9/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class SelectedEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var attendanceButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attendanceButton.backgroundColor = UIColor.greenColor()
    }
}
