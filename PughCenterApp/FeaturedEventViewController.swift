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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noFeaturedEventView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeAndDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.hidden = true
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = screenWidth / 2
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        WordpressClient.sharedInstance.getFeaturedEventInformation { (result, error) in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.noFeaturedEventView.hidden = false
                }
                
            } else {
                
                let imageURLString = result[WordpressClient.JSONResponseKeys.FeaturedEventImage] as? String
                let imageURL = NSURL(string: imageURLString!)
                let imageData = NSData(contentsOfURL: imageURL!)
                let image = UIImage (data: imageData!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.activityIndicator.stopAnimating()
                    self.scrollView.hidden = false
                    self.titleLabel.text = result[WordpressClient.JSONResponseKeys.FeaturedEventTitle] as? String
                    self.descriptionLabel.text = result[WordpressClient.JSONResponseKeys.FeaturedEventDescription] as? String
                    self.timeAndDateLabel.text = result[WordpressClient.JSONResponseKeys.FeaturedEventDateAndTime] as? String
                    self.imageView.image = image
                }
            }
        }
    }
}
