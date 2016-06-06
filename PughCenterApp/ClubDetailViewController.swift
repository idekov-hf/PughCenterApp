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
    @IBOutlet var clubDescription: UILabel!
    @IBOutlet var urlTextView: UITextView!
    @IBOutlet var urlHeightConstaint: NSLayoutConstraint!
    
    var clubNameString: String = ""
    var clubDescriptionString: String = ""
    var urlString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        clubName.text = clubNameString
        clubDescription.text = clubDescriptionString
        urlTextView.text = urlString
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let size = urlTextView.contentSize
        urlHeightConstaint.constant = size.height
    }

}

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}