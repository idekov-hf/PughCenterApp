//
//  ClubsTableViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

// MARK: - ClubsTableViewController
class ClubsTableViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var clubs = [Club]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 46.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Get club info from Pugh Wordpress API
        WordpressClient.sharedInstance.getClubs { (clubs, error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if let clubs = clubs {
                    
                    self.clubs = clubs
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                } else {
                    
                    self.displayAlert(error!)
                }
            }
        }
    }
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showClubDetails" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let detailsController = segue.destinationViewController as! ClubDetailViewController
            
            detailsController.club = clubs[indexPath.row]
        }
    }
    
    // MARK: Helper
    func displayAlert(error: String) {
        
        let alertController = UIAlertController(title: nil, message: error, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - ClubsTableViewController DataSource Methods
extension ClubsTableViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClubCell")!
        
        cell.textLabel!.text = clubs[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showClubDetails", sender: self)
    }
}
