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
	@IBOutlet var descriptionToSuperviewConstraint: NSLayoutConstraint!
	@IBOutlet var buttonToSuperviewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attendanceButton.backgroundColor = UIColor.greenColor()
    }
	
	func showAttendanceViews(cellExpanded: Bool) {
		
		attendanceButton.hidden = !cellExpanded
		attendanceLabel.hidden = !cellExpanded
		descriptionToSuperviewConstraint.priority = cellExpanded ? 500 : 999
		buttonToSuperviewConstraint.priority = cellExpanded ? 999 : 500
	}
}
