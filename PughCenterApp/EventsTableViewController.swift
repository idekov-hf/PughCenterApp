//
//  EventsTableViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/9/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var activityIndicator: UIActivityIndicatorView!
    static var outDateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, 'at' h:mm a"
        formatter.locale = NSLocale.currentLocale()
        return formatter
    }()
    var screenWidth: CGFloat = 0
    var events = [Event]()
    var selectedIndexPath: NSIndexPath?
    var deSelectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enables self sizing cells
        // http://www.appcoda.com/self-sizing-cells/
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.viewDidLayoutSubviews()
        
        // Loading indicator is displayed before event data has loaded
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = CGPointMake(view.center.x, view.center.y - 50)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Parse and set events field
        // cellForRowAtIndexPath uses the data 
        // from the events data field when the data is reloaded
//        let eventParser = EventParser()
//        eventParser.beginParsing()
//        events = eventParser.events
        
        // test local notifications with custom data
        loadCustomData()
        
        addLocalNotifications()
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func loadCustomData() {
        let event1 = Event(title: "Event 1", description: "This is a description of Event 1: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris scelerisque porttitor nunc, a vestibulum odio faucibus sed. Morbi in tortor nec enim rutrum auctor a eget leo. Integer vel dapibus turpis. Aliquam tempor vehicula sapien id varius. Duis nec sapien id eros imperdiet ullamcorper. ", startDate: NSDate().dateByAddingTimeInterval(1815))
        let event2 = Event(title: "Event 2", description: "This is a short description of Event 2", startDate: NSDate().dateByAddingTimeInterval(1830))
        let event3 = Event(title: "Event 3", description: "This is a description of Event 3: Proin enim arcu, commodo eu tellus eu, eleifend iaculis eros. Nam id ante placerat, malesuada metus eu, varius dolor. In eu eros posuere magna tincidunt maximus nec sed dui. Nam condimentum massa ut auctor porta.", startDate: NSDate().dateByAddingTimeInterval(1845))
        events += [event1, event2, event3]
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
    
    override func viewDidLayoutSubviews() {
        self.screenWidth = self.view.frame.size.width
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
        if indexPath == selectedIndexPath {
            cellID = "SelectedCell"
        }
        else {
            cellID = "UnselectedCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! EventsTableViewCell
        let dateAsString = EventsTableViewController.outDateFormatter.stringFromDate(events[indexPath.row].startDate!)
        cell.titleLabel.text = events[indexPath.row].title
        cell.dateLabel.text = dateAsString
        
        if indexPath == selectedIndexPath {
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.descriptionLabel.text = events[indexPath.row].eventDescription
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPathArray = [NSIndexPath]()
        
        deSelectedIndexPath = selectedIndexPath
        if let deSelectedIndexPath = deSelectedIndexPath {
            indexPathArray.append(deSelectedIndexPath)
        }
        
        selectedIndexPath = indexPath
        indexPathArray.append(indexPath)
        
        tableView.reloadRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        
    }

}
