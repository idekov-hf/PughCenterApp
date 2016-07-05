//
//  NotificationsViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 6/12/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var notificationData: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadData()
    }
    
    func loadData() {
        let query = PFQuery(className: "Notification")
        query.orderByDescending("createdAt")
        query.limit = 10
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // Do something with the found objects
                self.notificationData = objects
                self.tableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}

// MARK: Table View Data Source Methods
extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = notificationData {
            return data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationTableViewCell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        if let notification = notificationData?[indexPath.row] {
            let dateAsString = DateFormatters.outDateFormatter.stringFromDate(notification.createdAt!)
            
            cell.titleLabel.text = notification["title"] as? String
            cell.messageTextView.text = notification["message"] as? String
            cell.dateLabel.text = "Sent on \(dateAsString)"

        }

        return cell
    }
    
}

// MARK: Table View Delegate Methods
extension NotificationsViewController: UITableViewDelegate {
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        <#code#>
//    }
    
}