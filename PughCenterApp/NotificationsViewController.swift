//
//  NotificationsViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 6/12/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}

// MARK: Table View Data Source Methods
extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: return correct number of rows in section
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationTableViewCell", forIndexPath: indexPath)
        
        return cell
    }
    
}