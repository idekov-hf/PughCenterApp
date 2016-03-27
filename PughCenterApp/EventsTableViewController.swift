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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EventsTableViewCell
        let dateAsString = EventsTableViewController.outDateFormatter.stringFromDate(events[indexPath.row].startDate!)
//        cell.textLabel?.text = events[indexPath.row].title
//        cell.detailTextLabel!.text = dateAsString
        cell.titleLabel.text = events[indexPath.row].title
        cell.dateLabel.text = dateAsString

        return cell
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
