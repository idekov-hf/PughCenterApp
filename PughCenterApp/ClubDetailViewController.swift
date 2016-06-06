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
    @IBOutlet var imageView: UIImageView!
    
    var clubNameString: String = ""
    var clubDescriptionString: String = ""
    var urlString: String = ""
    var imageURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        clubName.text = clubNameString
        clubDescription.text = clubDescriptionString
        urlTextView.text = urlString
        loadImage(imageURL)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let size = urlTextView.contentSize
        urlHeightConstaint.constant = size.height
    }
    
    func loadImage(imageURL: String) {
        
        if imageURL != "" {
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,  0)) {
                let url = NSURL(string: imageURL)
                let imageData = NSData(contentsOfURL: url!)
                let image = UIImage (data: imageData!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.imageView.image = image
                }
            }
            
        }
        
    }

}