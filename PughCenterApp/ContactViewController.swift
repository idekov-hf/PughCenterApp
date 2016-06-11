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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var screenWidth: CGFloat = 0
    
    let url = NSURL(string: "https://www.colby.edu/pugh/wp-json/colby-rest/v0/acf-options?additional_contacts=1")!
    
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
            
            guard let contactsArray = parsedResult["additional_contacts"] as? [[String : AnyObject]] else {
                print("Contact info not succesfully extracted")
                return
            }
            
            self.displayContactInfo(contactsArray)
            
        }
        
        // start the task
        task.resume()
    }
    
    func displayContactInfo(contactsArray: [[String : AnyObject]]) {
        
        let currentString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let contactsString = NSMutableAttributedString(string: "\n\n")
        
        let boldTextAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14), ]
        let regularTextAttribute = [NSFontAttributeName: UIFont.systemFontOfSize(14)]
        
        let phoneTitle = NSAttributedString(string: "Phone: ", attributes: boldTextAttribute)
        let emailTitle = NSAttributedString(string: "E-mail: ", attributes: boldTextAttribute)
        
        for contact in contactsArray {
            let name = NSAttributedString(string: "\(contact["name"] as! String)\n", attributes: boldTextAttribute)
            contactsString.appendAttributedString(name)
            
            let title = NSAttributedString(string: "\(contact["title"] as! String)\n", attributes: regularTextAttribute)
            contactsString.appendAttributedString(title)
            
            contactsString.appendAttributedString(phoneTitle)
            
            let phone = NSAttributedString(string: "\(contact["phone"] as! String)\n", attributes: regularTextAttribute)
            contactsString.appendAttributedString(phone)
            
            contactsString.appendAttributedString(emailTitle)
            
            let email = NSAttributedString(string: "\(contact["email"] as! String)\n\n", attributes: regularTextAttribute)
            contactsString.appendAttributedString(email)
        }
        
        currentString.appendAttributedString(contactsString)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            self.textView.attributedText = currentString
            self.textView.textAlignment = NSTextAlignment.Center
            self.textView.hidden = false
        }
    }

}
