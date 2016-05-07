//
//  ClubsTableViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class ClubsTableViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    
    var screenWidth: CGFloat = 0
    
    var clubs = [Club]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDidLayoutSubviews()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.screenWidth = self.view.frame.size.width
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showClubDetails" {
            
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow!
            
            let detailsController = segue.destinationViewController as! ClubDetailViewController
            
            detailsController.clubNameString = clubNames[indexPath.row]
            detailsController.clubDescriptionString = clubDescriptions[clubNames[indexPath.row]]!
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ClubNameCell")!
        
        cell.textLabel!.text = clubs[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showClubDetails", sender: self)
    }
    
}
