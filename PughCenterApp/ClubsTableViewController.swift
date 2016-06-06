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
    
    let url = NSURL(string: "https://www.colby.edu/pugh/wp-json/colby-rest/v0/acf-options?clubs=1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDidLayoutSubviews()
        
        tableView.estimatedRowHeight = 46.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadClubs()
    }
    
    override func viewDidLayoutSubviews() {
        self.screenWidth = self.view.frame.size.width
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showClubDetails" {
            
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow!
            
            let detailsController = segue.destinationViewController as! ClubDetailViewController
            
            detailsController.clubNameString = clubs[indexPath.row].name
            detailsController.clubDescriptionString = clubs[indexPath.row].description
            detailsController.urlString = clubs[indexPath.row].url
        }
    }
    
    // MARK: - UITableView DataSource and Delegate Methods
    
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
    
    // MARK: - Wordpress JSON Parsing Methods
    
    func loadClubs() {
        
        // create request
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        
        // create network request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it
            func displayError(error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // get list of club dictionaries form the parsed results
            guard let clubsList = parsedResult["clubs"] as? [[String: AnyObject]] else {
                print("clubList was not succesfully parsed")
                return
            }
            
            // create each club object and fill in details
            for club in clubsList {
                let name = club["title"] as! String
                let description = club["description"] as! String
                let url = club["url"] as! String
                self.clubs.append(Club(name: name, description: description, url: url))
            }
            
            // update the table view
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        
        }
        
        // start the task!
        task.resume()
        
    }
    
}
