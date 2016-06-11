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
    var eventSelected = false
    
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
        let eventParser = EventParser()
        eventParser.beginParsing()
        events = eventParser.events
        
        addLocalNotifications()
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        tableView.reloadData()
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
        if indexPath == selectedIndexPath && eventSelected == true {
            cellID = "SelectedCell"
        }
        else {
            cellID = "UnselectedCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! EventsTableViewCell
        let dateAsString = EventsTableViewController.outDateFormatter.stringFromDate(events[indexPath.row].startDate!)
        cell.titleLabel.text = events[indexPath.row].title
        cell.dateLabel.text = dateAsString
        
        if indexPath == selectedIndexPath && eventSelected == true {
            cell.descriptionLabel.text = events[indexPath.row].eventDescription
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

}
