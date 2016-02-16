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
