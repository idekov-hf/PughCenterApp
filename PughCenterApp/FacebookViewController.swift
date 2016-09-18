//
//  FacebookViewController.swift
//  PughCenterApp
//
//  Created by Iavor V. Dekov on 2/18/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

// MARK: - FacebookViewController
class FacebookViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var webView: UIWebView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            let url = NSURL (string: "https://www.facebook.com/colby.pugh.10");
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
        }
    }

}
