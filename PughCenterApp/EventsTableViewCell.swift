//
//  EventsTableViewCell.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/9/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var attendanceButton: UIButton!
    
    @IBAction func attendanceButtonPressed(sender: UIButton) {
        if attendanceButton.currentTitle == "Going" {
        attendanceLabel.text = "1"
        attendanceButton.setTitle("Can't go", forState: .Normal)
        }
        else {
            attendanceLabel.text = "0"
            attendanceButton.setTitle("Going", forState: .Normal)
        }
        
    }
    
    
}
