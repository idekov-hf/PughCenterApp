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
    
    var screenWidth: CGFloat = 0

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
