//
//  ParseClient.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 8/11/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation
import Parse

// MARK: - ParseClient
class ParseClient {
    
    // MARK: Shared Instance
    static var sharedInstance = ParseClient()
    
    func getAttendanceCountForEvent(url: String) {
        let query = PFQuery(className: ClassNames.Event)
        query.whereKey(Fields.URL, equalTo: url)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
        }
    }
}

extension ParseClient {
    
    struct ClassNames {
        
        static let Event = "Event"
    }
    
    struct Fields {
        
        static let Attendance = "attendance"
        static let URL = "link"
    }
}