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
    
    func getAttendanceCountForEvent(url: String, completionHandler: (attendanceCount: Int) -> Void) {
        let query = PFQuery(className: ClassNames.Event)
        query.whereKey(Keys.URL, equalTo: url)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let eventObjects = objects where eventObjects.count > 0 else {
                print("Could not find pfObjects with the specified URL value")
                return
            }
            
            let event = eventObjects[0]
            let attendance = event[Keys.Attendance] as! Int
            completionHandler(attendanceCount: attendance)
        }
    }
}

extension ParseClient {
    
    struct ClassNames {
        
        static let Event = "Event"
    }
    
    struct Keys {
        
        static let Attendance = "attendance"
        static let URL = "link"
    }
}