//
//  ClubDetailViewController.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class ClubDetailViewController: UIViewController {
    
    @IBOutlet var clubName: UILabel!
    @IBOutlet var clubDescription: UITextView!
    
    var clubNameString: String = ""
    var clubDescriptionString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clubName.text = self.clubNameString
        self.clubDescription.text = self.clubDescriptionString
    }

}
