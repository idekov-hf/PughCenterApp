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
	
//	let greenColor = UIColor(red: 133/255, green: 253/255, blue: 137/255, alpha: 1)
//	let greenColor = UIColor(red: 217/255, green: 245/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red:0.00, green:0.16, blue:0.47, alpha:1.0)
	let redColor = UIColor(red: 255/255, green: 154/255, blue: 134/255, alpha: 1)
//	let highlightedColor = UIColor(red: 236/255, green: 255/255, blue: 253/255, alpha: 1)
//	let highlightedColor = UIColor(red: 204/255, green: 222/255, blue: 255/255, alpha: 1)
//    let highlightedColor = UIColor(red: 235/255, green: 241/255, blue: 255/255, alpha: 1)
    let highlightedColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
	let whiteColor = UIColor.whiteColor()
	
	override func awakeFromNib() {
		super.awakeFromNib()
//		attendanceButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
		attendanceButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
	}
	
	var buttonTitle: Attendance! {
		didSet {
			attendanceButton.setTitle(buttonTitle.rawValue, forState: .Normal)
			attendanceButton.setTitleColor(whiteColor, forState: .Normal)
			attendanceButton.backgroundColor = buttonTitle == Attendance.RSVP ? greenColor : nil
		}
	}
	
	func expandCell(expand: Bool) {
		contentView.backgroundColor = expand ? highlightedColor : whiteColor
		descriptionLabel.textColor = expand ? UIColor.blackColor() : UIColor.grayColor()
		showAttendanceViews(expand)
	}
	
	func showAttendanceViews(cellExpanded: Bool) {
		
		attendanceButton.hidden = !cellExpanded
		attendanceLabel.hidden = !cellExpanded
		descriptionToSuperviewConstraint.priority = cellExpanded ? 500 : 999
		buttonToSuperviewConstraint.priority = cellExpanded ? 999 : 500
	}
}
