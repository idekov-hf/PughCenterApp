//
//  Event.swift
//  NSXMLTest
//
//  Created by Iavor Dekov on 3/5/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    
    // MARK: Properties
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("event")
    
    var title: String
    var eventDescription: String
    var startDate: NSDate?
    
    // MARK: Types
    
    struct PropertyKey {
        static let titleKey = "title"
        static let descriptionKey = "description"
        static let startDateKey = "startDate"
    }
    
    // Mark: Initialization
    
    init(title: String, description: String, startDate: NSDate) {
        // Initializes stored properties.
        self.title = title
        self.eventDescription = description
        self.startDate = startDate
        super.init()
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(description, forKey: PropertyKey.descriptionKey)
        aCoder.encodeObject(startDate, forKey: PropertyKey.startDateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let description = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as! String
        
        let startDate = aDecoder.decodeObjectForKey(PropertyKey.startDateKey) as! NSDate
        
        // Must call designated initializer.
        self.init(title: title, description: description, startDate: startDate)
    }
    
}