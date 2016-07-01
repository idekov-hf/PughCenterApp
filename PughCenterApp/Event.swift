//
//  Event.swift
//  NSXMLTest
//
//  Created by Iavor Dekov on 3/5/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

class Event {
    
    // MARK: Properties
    
    var title: String
    var eventDescription: String
    var startDate: NSDate?
    var link: String
    var buttonStatus: String
    var parseObjectID: String?
    
    // Mark: Initialization
    
    init(title: String, description: String, startDate: NSDate, link: String, buttonStatus: String, parseObjectID: String?) {
        // Initializes stored properties.
        self.title = title
        self.eventDescription = description
        self.startDate = startDate
        self.link = link
        self.buttonStatus = buttonStatus
        self.parseObjectID = parseObjectID
    }
}

struct DateFormatters {
    // Static Properties
    static var inDateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()
    
    static var outDateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, 'at' h:mm a"
        formatter.locale = NSLocale.currentLocale()
        return formatter
    }()
}