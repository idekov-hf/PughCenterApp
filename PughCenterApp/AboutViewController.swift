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
    
    var screenWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLayoutSubviews()
        
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenWidth = view.frame.size.width
        textView.setContentOffset(CGPointMake(0, 0), animated: false)
    }

}
