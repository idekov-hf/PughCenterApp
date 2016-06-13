//
//  EventParser.swift
//  NSXMLTest
//
//  Created by Iavor Dekov on 3/2/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

class EventParser: NSObject, NSXMLParserDelegate {
    
    var parser: NSXMLParser
    var elementValue: String = ""
    var events = [Event]()
    var event: Event?
    var eventTitle: String = ""
    var eventDescription: String = ""
    var eventDate: NSDate?
    
    static var inDateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()
    
    override init() {
        let url = NSURL(string: "https://www.colby.edu/pugh/events-feed/")!
        self.parser = NSXMLParser(contentsOfURL: url)!
        super.init()
        self.parser.delegate = self
    }
    
    func beginParsing() {
        self.parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementValue = ""
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.elementValue += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "title":
                eventTitle = elementValue
            case "description":
                eventDescription = elementValue
            case "ev:startdate":
                eventDate = EventParser.inDateFormatter.dateFromString(elementValue)!
            case "item":
                eventDescription = eventDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                // trim description string (remove whitespace from beginning and end)
                events += [Event(title: eventTitle, description: eventDescription, startDate: eventDate!)]
            default: break
            
        }
    }
    
}