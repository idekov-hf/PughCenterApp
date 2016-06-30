//
//  EventsTableViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/9/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Parse

class EventsTableViewController: UITableViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    let eventParser = EventParser()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var activityIndicator: UIActivityIndicatorView!
    var events = [Event]()
    var buttonTitleDictionary: [String: String]!
    var selectedIndexPath: NSIndexPath?
    var deSelectedIndexPath: NSIndexPath?
    var eventSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enables self sizing cells
        // http://www.appcoda.com/self-sizing-cells/
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Loading indicator is displayed before event data has loaded
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = CGPointMake(view.center.x, view.center.y - 50)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadTableData), name: "reloadData", object: nil)
        // get XML data, initialize NSXMLParser object with data as parameter & parse the data
        eventParser.beginParsing()
    }
    
    func reloadTableData(notification: NSNotification) {
        if notification.name == "reloadData" {
            // Transfer the dictionary containing the button title for each unique Event link from the eventParser object to the EventsTableViewController
            buttonTitleDictionary = eventParser.newLinkDictionary
            // Transfer the array of events from the eventParser object to the EventsTableViewController
            events = eventParser.events
            // Reload the table contents in the main queue
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            // Add local notifications for each event
            addLocalNotifications()
            // Remove the observer for the reloadData notification call
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadData", object: nil)
        }
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

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellID: String
        if indexPath == selectedIndexPath && eventSelected == true {
            cellID = "SelectedCell"
        }
        else {
            cellID = "UnselectedCell"
        }
        
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! EventsTableViewCell
        let dateAsString = DateFormatters.outDateFormatter.stringFromDate(event.startDate!)
        cell.titleLabel.text = event.title
        cell.dateLabel.text = dateAsString
        
        if cellID == "SelectedCell" {
            cell.descriptionLabel.text = event.eventDescription
            cell.attendanceButton.setTitle(event.buttonStatus, forState: .Normal)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var indexPathArray = [NSIndexPath]()
        
        if indexPath == selectedIndexPath && eventSelected {
            eventSelected = false
        }
        else {
            eventSelected = true
            deSelectedIndexPath = selectedIndexPath
            if let deSelectedIndexPath = deSelectedIndexPath {
                indexPathArray.append(deSelectedIndexPath)
            }
        }
        
        selectedIndexPath = indexPath
        indexPathArray.append(indexPath)
        
        tableView.reloadRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Automatic)
        if eventSelected {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
    }
    
    @IBAction func attendanceButtonPressed(sender: UIButton) {
        if let selectedRow = selectedIndexPath?.row {
            let buttonTitle = sender.titleLabel?.text
            let newTitle = buttonTitle == "RSVP" ? "Cancel" : "RSVP"
            // Set the button's new title
            sender.setTitle(newTitle, forState: .Normal)
            
            adjustAttendanceCount(buttonTitle!, row: selectedRow)
            
            // Update the title of the button associated with the selected Event
            events[selectedRow].buttonStatus = newTitle
            // Update the title associated with the Events link field in the button title dictionary
            buttonTitleDictionary[events[selectedRow].link] = newTitle
            // Persist the button title dictionary
            defaults.setObject(buttonTitleDictionary, forKey: "linkDictionary")
            defaults.synchronize()
        }
    }
    
    func adjustAttendanceCount(eventTitle: String, row: Int) {
        
        // If the event has a parseObjectID, adjust the attendance count
        if let objectID = events[row].parseObjectID {
            let query = PFQuery(className: "Event")
            query.getObjectInBackgroundWithId(objectID) {
                (eventObject: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let event = eventObject {
                    if eventTitle == "RSVP" {
                        event.incrementKey("attendance")
                    }
                    else {
                        event.incrementKey("attendance", byAmount: -1)
                    }
                    event.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The score key has been incremented
                            print("Succesfully incremented attendance counter")
                        } else {
                            // There was a problem, check error.description
                            print(error?.description)
                        }
                    }
                }
            }
        }
        // If it doesn't, create a new PFObject and set the attendance to 1
        else {
            
            let eventObject = PFObject(className: "Event")
            eventObject["attendance"] = 1
            eventObject.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved. Save the objectId
                    self.events[row].parseObjectID = eventObject.objectId
                } else {
                    // There was a problem, check error.description
                    print("Did not save object in background because: \(error?.description)")
                }
            }
            
        }
        
    }
}
