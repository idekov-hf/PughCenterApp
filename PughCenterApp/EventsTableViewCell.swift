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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var descriptionToSuperviewConstraint: NSLayoutConstraint!
	@IBOutlet var buttonToSuperviewConstraint: NSLayoutConstraint!
	
	let greenColor = UIColor(red: 133/255, green: 253/255, blue: 137/255, alpha: 1)
	let redColor = UIColor(red: 255/255, green: 154/255, blue: 134/255, alpha: 1)
	
	var buttonTitle: Attendance! {
		didSet {
			attendanceButton.setTitle(buttonTitle.rawValue, forState: .Normal)
			attendanceButton.backgroundColor = buttonTitle == Attendance.RSVP ? greenColor : redColor
		}
	}
	
	func showAttendanceViews(cellExpanded: Bool) {
		
		attendanceButton.hidden = !cellExpanded
		attendanceLabel.hidden = !cellExpanded
		descriptionToSuperviewConstraint.priority = cellExpanded ? 500 : 999
		buttonToSuperviewConstraint.priority = cellExpanded ? 999 : 500
	}
}
