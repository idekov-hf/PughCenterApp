//
//  FeaturedEventViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 8/24/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

// MARK: - FeaturedEventViewController
class FeaturedEventViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
