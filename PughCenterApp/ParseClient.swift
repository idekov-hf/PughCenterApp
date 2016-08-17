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
        query.whereKey(Keys.Link, equalTo: url)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let eventObjects = objects where eventObjects.count > 0 else {
                print("Could not find pfObjects with the specified URL value")
				self.createNewEventObject(url)
				completionHandler(attendanceCount: 0)
                return
            }
            
            let event = eventObjects[0]
            let attendance = event[Keys.Attendance] as! Int
            completionHandler(attendanceCount: attendance)
        }
    }
	
	func createNewEventObject(url: String) {
		
		let eventObject = PFObject(className: ClassNames.Event)
		eventObject[Keys.Attendance] = 0
		eventObject[Keys.Link] = url
		eventObject.saveInBackground()
	}
	
	func adjustAttendanceCount(eventTitle: String, eventURL: String, row: Int, completionHandler: (count: Int) -> Void) {
		
		// Query the Parse database in order to find a PFObject using the link of the event associated with the selected cell
		let query = PFQuery(className: ClassNames.Event)
		query.whereKey(Keys.Link, equalTo: eventURL)
		query.findObjectsInBackgroundWithBlock {
			(objects: [PFObject]?, error: NSError?) -> Void in
			// If there is an error, print it out
			if error != nil {
				print("Error: \(error!)")
			}
				// If the array contains more than 0 objects, increment/decrement the attendance counter
			else if let objects = objects where objects.count > 0 {
				
				let event = objects[0]
				var count = event[Keys.Attendance] as! Int
				if eventTitle == Attendance.RSVP.rawValue {
					event.incrementKey(Keys.Attendance)
					count += 1
				}
				else {
					event.incrementKey(Keys.Attendance, byAmount: -1)
					count -= 1
				}
				
				event.saveInBackgroundWithBlock {
					(success: Bool, error: NSError?) -> Void in
					if (success) {
						completionHandler(count: count)
					} else {
						// There was a problem, check error.description
						print("Save not successful because: \(error?.description)")
					}
				}
			}
		}
	}
}

extension ParseClient {
	
    struct ClassNames {
		
        static let Event = "Event"
    }
	
    struct Keys {
		
        static let Attendance = "attendance"
        static let Link = "link"
    }
}