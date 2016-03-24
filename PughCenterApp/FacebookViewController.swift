//
//  FacebookViewController.swift
//  PughCenterApp
//
//  Created by Iavor V. Dekov on 2/18/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class FacebookViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var webView: UIWebView!
    
    var screenWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDidLayoutSubviews()
        
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
    
    override func viewDidLayoutSubviews() {
        self.screenWidth = self.view.frame.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
