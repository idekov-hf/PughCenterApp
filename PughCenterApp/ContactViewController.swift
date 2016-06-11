//
//  ContactViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/10/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    var screenWidth: CGFloat = 0
    
    let url = NSURL(string: "http://www.colby.edu/pugh/wp-json/colby-rest/v0/acf-options?additional_contacts=1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDidLayoutSubviews()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadContactInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.screenWidth = self.view.frame.size.width
    }
    
    func loadContactInfo() {
        
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
            
            guard let text = parsedResult["additional_contacts"] as? [[String : AnyObject]] else {
                print("Contact info not succesfully extracted")
                return
            }
            
            print(text)
            
            dispatch_async(dispatch_get_main_queue()) {
                
            }
            
        }
        
        // start the task
        task.resume()
    }

}
