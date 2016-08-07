//
//  Convenience.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 8/7/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

extension WordpressClient {
    
    func getClubs(completionHandler: (clubs: [Club]?, error: String?) -> Void) {
        
        let parameters = [
            ParameterKeys.Clubs: ParameterValues.Show
        ]
        
        taskForGETMethod(parameters) { (result, error) in
            
            guard error == nil else {
                completionHandler(clubs: nil, error: "Could not load clubs, please check your internet connection and try again.")
                return
            }
            
            // Get list of club dictionaries
            guard let clubsList = result["clubs"] as? [[String: AnyObject]] else {
                print("clubList was not succesfully parsed")
                return
            }
            
            var clubs = [Club]()
            
            // Create each club object and fill in details
            for club in clubsList {
                
                let name = club["title"] as! String
                let description = club["description"] as! String
                let url = club["url"] as! String
                var imageURL = ""
                if let url = club["image"] as? String {
                    imageURL = url
                }
                
                let club = Club(name: name, description: description, url: url, imageURL: imageURL)
                
                clubs.append(club)
            }
            
            completionHandler(clubs: clubs, error: nil)
        }
    }
}