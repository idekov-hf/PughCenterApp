//
//  EventsTableViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/9/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Parse

// MARK: - EventsTableViewController
class EventsTableViewController: UIViewController {
	
	// MARK: Outlets
    @IBOutlet var menuButton: UIBarButtonItem!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noEventsView: UIView!
	
	// MARK: Properties
    let eventParser = EventParser()
    let defaults = NSUserDefaults.standardUserDefaults()
//	let greenColor = UIColor(red: 133/255, green: 253/255, blue: 137/255, alpha: 1)
//	let greenColor = UIColor(red: 191/255, green: 255/255, blue: 122/255, alpha: 1)
	let greenColor = UIColor(red: 63/255, green: 144/255, blue: 79/255, alpha: 1)
	let redColor = UIColor(red: 255/255, green: 154/255, blue: 134/255, alpha: 1)
	let eventDescriptionText = "Press for event description >"
//    let highlightedColor = UIColor(red: 236/255, green: 255/255, blue: 253/255, alpha: 1)
    
    let whiteColor = UIColor.whiteColor()
	
    var events = [Event]()
    var linkDictionary: [String: String]!
    var selectedIndexPath: NSIndexPath?
    var deSelectedIndexPath: NSIndexPath?
    var eventSelected = false
	
	// MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventParser.delegate = self
        
        // Enables self sizing cells
        // http://www.appcoda.com/self-sizing-cells/
        tableView.estimatedRowHeight = 125
        tableView.rowHeight = UITableViewAutomaticDimension
		
        activityIndicator.startAnimating()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // get XML data, initialize NSXMLParser object with data as parameter & parse the data
        eventParser.beginParsing()
    }
    
    func addLocalNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        for event in events {
            let notification = UILocalNotification()
            notification.fireDate = event.startDate?.dateByAddingTimeInterval(-1800)
            notification.alertBody = event.title + " is starting in 30 minutes."
            notification.soundName = UILocalNotificationDefaultSoundName

            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
	
	// MARK: Actions
    @IBAction func attendanceButtonPressed(sender: UIButton) {
        if let selectedRow = selectedIndexPath?.row {
            let buttonTitle = sender.titleLabel?.text
			
			let buttonBackgroundColor = buttonTitle == Attendance.RSVP.rawValue ? UIColor.clearColor() : greenColor
			sender.backgroundColor = buttonBackgroundColor
			
			let newTitle = buttonTitle == Attendance.RSVP.rawValue ? Attendance.Cancel.rawValue : Attendance.RSVP.rawValue
            sender.setTitle(newTitle, forState: .Normal)
			
			let eventURL = events[selectedRow].link
			
			setAttendanceEnabled(false, cell: tableView.cellForRowAtIndexPath(selectedIndexPath!) as! EventsTableViewCell)
			ParseClient.sharedInstance.adjustAttendanceCount(buttonTitle!, eventURL: eventURL, row: selectedRow) {
				count in
				
				let cell = self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as! EventsTableViewCell
				cell.attendanceLabel?.text = "\(count)"
				self.setAttendanceEnabled(true, cell: self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as! EventsTableViewCell)
			}
            
            // Update the title of the button associated with the selected Event
            events[selectedRow].buttonStatus = newTitle
            // Update the title associated with the Events link field in the link dictionary
            linkDictionary[events[selectedRow].link] = newTitle
            
            // Persist the button title dictionary
            defaults.setObject(linkDictionary, forKey: "linkDictionary")
            defaults.synchronize()
        }
    }
}

// MARK: - UITableView Data Source
extension EventsTableViewController: UITableViewDataSource {
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return events.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cellID = "EventsTableViewCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! EventsTableViewCell
		
		let event = events[indexPath.row]
		let eventIsExpanded = event.isExpanded
		
		cell.titleLabel.text = event.title
		let dateAsString = DateFormatters.outDateFormatter.stringFromDate(event.startDate!)
		cell.dateLabel.text = dateAsString
		cell.descriptionLabel.text = eventIsExpanded ? event.eventDescription : eventDescriptionText
		cell.attendanceButton.setTitle(event.buttonStatus, forState: .Normal)
        cell.attendanceButton.backgroundColor = event.buttonStatus == Attendance.RSVP.rawValue ? greenColor : redColor
		
        cell.expandCell(eventIsExpanded)
        
        if eventIsExpanded {
            setAttendanceEnabled(false, cell: cell)
            ParseClient.sharedInstance.getAttendanceCountForEvent(event.link, completionHandler: { (attendanceCount) in
                self.setAttendanceEnabled(true, cell: cell)
                cell.attendanceLabel.text = "\(attendanceCount)"
            })
        }
		
		return cell
	}
    
    func setAttendanceEnabled(bool: Bool, cell: EventsTableViewCell) {
        cell.attendanceButton.enabled = bool
		cell.attendanceLabel.hidden = !bool
		
        if bool {
            cell.activityIndicator.stopAnimating()
        } else {
            cell.activityIndicator.startAnimating()
        }
    }
}

// MARK: - UITableView Delegate
extension EventsTableViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		selectedIndexPath = indexPath
		
		expandCellAtIndexPath(!events[indexPath.row].isExpanded, indexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
		expandCellAtIndexPath(false, indexPath: indexPath)
	}
	
	func expandCellAtIndexPath(expand: Bool, indexPath: NSIndexPath) {
		
		let event = events[indexPath.row]
		let isExpanded = expand
		event.isExpanded = isExpanded
		
		guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? EventsTableViewCell else { return }
		
		cell.descriptionLabel.text = isExpanded ? event.eventDescription : eventDescriptionText
		cell.expandCell(isExpanded)
		
		UIView.animateWithDuration(0.3) {
			cell.contentView.layoutIfNeeded()
		}
		
		tableView.beginUpdates()
		tableView.endUpdates()
		
		if expand {
			setAttendanceEnabled(false, cell: cell)
			ParseClient.sharedInstance.getAttendanceCountForEvent(event.link, completionHandler: { (attendanceCount) in
				self.setAttendanceEnabled(true, cell: cell)
				cell.attendanceLabel.text = "\(attendanceCount)"
			})
		}
	}
}

// MARK: - EventParserDelegate
extension EventsTableViewController: EventParserDelegate {
    func didFinishParsing(sender: EventParser) {
        // Transfer the dictionary containing the button title for each unique Event link from the eventParser object to the EventsTableViewController
        linkDictionary = sender.newLinkDictionary
		
        // Transfer the array of events from the eventParser object to the EventsTableViewController
        events = sender.events
        
        // Reload the table contents in the main queue
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            if self.events.count > 0 {
                self.tableView.hidden = false
                self.noEventsView.hidden = true
                self.tableView.reloadData()
            } else {
                self.noEventsView.hidden = false
                self.tableView.hidden = true
            }
        }
        
        // Add local notifications for each event
        addLocalNotifications()
    }
}