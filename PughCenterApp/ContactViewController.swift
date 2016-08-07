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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Make a request to the WordPress API for the contact info and then display it in a separate method (displayContactInfo())
        WordpressClient.sharedInstance.getContactInformation { (result, error) in
            
            if error == nil {
                
                self.displayContactInfo(result)
            }
        }
    }
    
    func displayContactInfo(contactsArray: [[String : AnyObject]]) {
        
        // Attributed string that is currently in the textView in the IB
        let existingText = NSMutableAttributedString(attributedString: textView.attributedText)
        
        // String which all the contact info will be appended to
        let contactsString = NSMutableAttributedString(string: "\n\n")
        
        // Attributes for the attributed text
        let boldTextAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(14), ]
        let regularTextAttribute = [NSFontAttributeName: UIFont.systemFontOfSize(14)]
        
        // Title text (will be bold)
        let phoneTitle = NSAttributedString(string: "Phone: ", attributes: boldTextAttribute)
        let emailTitle = NSAttributedString(string: "E-mail: ", attributes: boldTextAttribute)
        
        // Loop through contacts array and concatenate all the text into 1 string (contactsString)
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
        
        // Concatenate pre-existing text (in the IB textView) with the contactsString
        existingText.appendAttributedString(contactsString)
        
        // Update the UI on main queue (turn off indicator, set textView.attributedText)
        dispatch_async(dispatch_get_main_queue()) {
            self.activityIndicator.stopAnimating()
            self.textView.attributedText = existingText
            self.textView.textAlignment = NSTextAlignment.Center
            self.textView.hidden = false
        }
    }
}
