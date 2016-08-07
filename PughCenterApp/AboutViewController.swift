//
//  AboutViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/10/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        titleLabel.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        WordpressClient.sharedInstance.getAboutText { (result, error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if error == nil {
                    
                    self.activityIndicator.stopAnimating()
                    self.titleLabel.hidden = false
                    self.textView.text = result
                    self.textView.textColor = UIColor(red: 0.1, green: 0.3, blue: 0.5, alpha: 1)
                }
            }
        }
    }
}
