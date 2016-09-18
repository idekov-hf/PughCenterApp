//
//  SWRevealViewControllerTest.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 6/12/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

// MARK: - SWRevealViewControllerTest
class SWRevealViewControllerTest: SWRevealViewController {
    
    var notificationReceived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rearViewController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController")
        if notificationReceived {
            let navigationController = storyboard?.instantiateViewControllerWithIdentifier("NotificationsNavigationController") as! UINavigationController
            frontViewController = navigationController
        }
        else {
            
            frontViewController = storyboard?.instantiateViewControllerWithIdentifier("FeaturedEventNavigationController")
        }
    }
    
}
