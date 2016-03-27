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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enables self sizing cells
        // http://www.appcoda.com/self-sizing-cells/
        tableView.estimatedRowHeight = 65.0
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
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.screenWidth = self.view.frame.size.width
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            cell.descriptionLabel.text = events[indexPath.row].eventDescription
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        selectedIndexPath = indexPath
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventsTableViewCell
//        cell.descriptionLabel.text = events[indexPath.row].eventDescription
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//        tableView.reloadData()
//    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventsTableViewCell
//        cell.descriptionLabel.text = ""
//        tableView.reloadData()
//    }

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if (selectedIndexPath == indexPath) {
//            let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventsTableViewCell
//            cell.descriptionLabel.hidden = false
//            return cell.frame.height
//        }
//        return UITableViewAutomaticDimension
//    }

}
