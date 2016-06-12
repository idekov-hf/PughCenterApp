//
//  SWRevealViewControllerTest.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 6/12/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class SWRevealViewControllerTest: SWRevealViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rearViewController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController")
        frontViewController = storyboard?.instantiateViewControllerWithIdentifier("EventsViewController")
    }
    
}
