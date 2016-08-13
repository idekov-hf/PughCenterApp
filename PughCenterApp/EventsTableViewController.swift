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
	
	// MARK: Properties
    let eventParser = EventParser()
    let defaults = NSUserDefaults.standardUserDefaults()
	let greenColor = UIColor(red: 133/255, green: 253/255, blue: 137/255, alpha: 1)
	let redColor = UIColor(red: 255/255, green: 154/255, blue: 134/255, alpha: 1)
	let eventDescriptionText = "Press for event description >"
    let highlightedColor = UIColor(red: 236/255, green: 255/255, blue: 253/255, alpha: 1)
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
        tableView.estimatedRowHeight = 122
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
			
			let buttonBackgroundColor = buttonTitle == Attendance.RSVP.rawValue ? redColor : greenColor
			sender.backgroundColor = buttonBackgroundColor
			
			let newTitle = buttonTitle == Attendance.RSVP.rawValue ? Attendance.Cancel.rawValue : Attendance.RSVP.rawValue
            sender.setTitle(newTitle, forState: .Normal)
			
            adjustAttendanceData(buttonTitle!, row: selectedRow)
            
            // Update the title of the button associated with the selected Event
            events[selectedRow].buttonStatus = newTitle
            // Update the title associated with the Events link field in the link dictionary
            linkDictionary[events[selectedRow].link] = newTitle
            
            // Persist the button title dictionary
            defaults.setObject(linkDictionary, forKey: "linkDictionary")
            defaults.synchronize()
        }
    }
        
    func adjustAttendanceCount(indexPath: NSIndexPath) {
        let query = PFQuery(className: "Event")
        query.whereKey("link", equalTo: events[indexPath.row].link)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            // If the object exists, update the attendanceLabel.text value of the appropriate cell
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EventsTableViewCell
            guard error == nil else {
                print(error)
                return
            }
            guard let pfObjects = objects where pfObjects.count > 0 else {
                cell.attendanceLabel?.text = "0"
                return
            }
            let event = pfObjects[0]
            cell.attendanceLabel?.text = "\(event["attendance"])"
        }
    }
    
    func adjustCountOnPress(count: Int) {
        let cell = self.tableView.cellForRowAtIndexPath(selectedIndexPath!) as! EventsTableViewCell
        cell.attendanceLabel?.text = "\(count)"
    }
    
    func adjustAttendanceData(eventTitle: String, row: Int) {
		
		setAttendanceEnabled(false, cell: tableView.cellForRowAtIndexPath(selectedIndexPath!) as! EventsTableViewCell)
        // Query the Parse database in order to find a PFObject using the link of the event associated with the selected cell
        let query = PFQuery(className: "Event")
        query.whereKey("link", equalTo: events[row].link)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            // If there is an error, print it out
            if error != nil {
                print("Error: \(error!)")
            }
            // If the array contains more than 0 objects, increment/decrement the attendance counter
            else if let objects = objects where objects.count > 0 {
				
                let event = objects[0]
                var count = event["attendance"] as! Int
                if eventTitle == Attendance.RSVP.rawValue {
                    event.incrementKey("attendance")
                    count += 1
                }
                else {
                    event.incrementKey("attendance", byAmount: -1)
                    count -= 1
                }
                self.adjustCountOnPress(count)
                event.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                    } else {
                        // There was a problem, check error.description
                        print("Save not successful because: \(error?.description)")
                    }
                }
				
				self.setAttendanceEnabled(true, cell: self.tableView.cellForRowAtIndexPath(self.selectedIndexPath!) as! EventsTableViewCell)
            }
            // If it doesn't, create a new PFObject, set the attendance field to 1 and set the link field as well
            else {
                let eventObject = PFObject(className: "Event")
                self.adjustCountOnPress(1)
                eventObject["attendance"] = 1
                eventObject["link"] = self.events[row].link
                eventObject.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved, update the attendance count of the event cell
                    } else {
                        // There was a problem, check error.description
                        print("Did not save object in background because: \(error?.description)")
                    }
                }
            }
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
		
		let dateAsString = DateFormatters.outDateFormatter.stringFromDate(event.startDate!)
		
		cell.titleLabel.text = event.title
		cell.dateLabel.text = dateAsString
		
		cell.descriptionLabel.text = eventIsExpanded ? event.eventDescription : eventDescriptionText
		cell.descriptionLabel.textColor = eventIsExpanded ? UIColor.blackColor() : UIColor.grayColor()
        cell.contentView.backgroundColor = eventIsExpanded ? highlightedColor : whiteColor
		cell.attendanceButton.backgroundColor = event.buttonStatus == Attendance.RSVP.rawValue ? greenColor : redColor
		cell.attendanceButton.setTitle(event.buttonStatus, forState: .Normal)
		cell.showAttendanceViews(eventIsExpanded)
        
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
	
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		
//		// Array that will store the indexPaths to be reloaded
//		var paths = [NSIndexPath]()
//		
//		// Check if there is a previously selected index path
//		if let previouslySelectedPath = selectedIndexPath {
//			deSelectedIndexPath = previouslySelectedPath
//			selectedIndexPath = indexPath
//			
//			// Check if the previously selected index path is the same as the currently selected index path
//			if deSelectedIndexPath == indexPath {
//				events[indexPath.row].isExpanded = !events[indexPath.row].isExpanded
//				paths = [indexPath]
//			} else {
//				events[indexPath.row].isExpanded = true
//				events[deSelectedIndexPath!.row].isExpanded = false
//				paths = [indexPath, deSelectedIndexPath!]
//			}
//			
//		} else {
//		
//			selectedIndexPath = indexPath
//			events[indexPath.row].isExpanded = true
//			paths = [selectedIndexPath!]
//		}
//		
//		tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: .Automatic)
//		
//		tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
//	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		var indexPathArray = [NSIndexPath]()
		
		
		// Check if there is a previously selected index path
		if let previouslySelectedPath = selectedIndexPath {
			deSelectedIndexPath = previouslySelectedPath
			selectedIndexPath = indexPath
			
			// Check if the previously selected index path is the same as the currently selected index path
			if deSelectedIndexPath == indexPath {
                let shouldExpand = !events[indexPath.row].isExpanded
				events[indexPath.row].isExpanded = shouldExpand
				indexPathArray = [indexPath]
			} else {
				events[indexPath.row].isExpanded = true
				events[deSelectedIndexPath!.row].isExpanded = false
				indexPathArray = [indexPath, deSelectedIndexPath!]
			}
			
		} else {
			
			selectedIndexPath = indexPath
			events[indexPath.row].isExpanded = true
			indexPathArray = [indexPath]
		}
		
        expandCellsAtIndexPaths(indexPathArray)
		
		tableView.beginUpdates()
		tableView.endUpdates()
		
		tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
	}
	
    func expandCellsAtIndexPaths(indexPathArray: [NSIndexPath]) {
		
        for path in indexPathArray {
        
            guard let cell = tableView.cellForRowAtIndexPath(path) as? EventsTableViewCell else {
                return
            }
            let event = events[path.row]
            let isExpanded = event.isExpanded
            cell.descriptionLabel.text = isExpanded ? event.eventDescription : eventDescriptionText
            cell.descriptionLabel.textColor = isExpanded ? UIColor.blackColor() : UIColor.grayColor()
            cell.contentView.backgroundColor = isExpanded ? highlightedColor : whiteColor
            cell.attendanceButton.setTitle(event.buttonStatus, forState: .Normal)
            cell.showAttendanceViews(isExpanded)
            
            UIView.animateWithDuration(0.3) {
                cell.contentView.layoutIfNeeded()
            }
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
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        // Add local notifications for each event
        addLocalNotifications()
    }
}