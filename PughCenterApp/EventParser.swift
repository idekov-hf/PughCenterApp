//
//  EventParser.swift
//  NSXMLTest
//
//  Created by Iavor Dekov on 3/2/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

class EventParser: NSObject, NSXMLParserDelegate {
    
    let url = NSURL(string: "https://www.colby.edu/pugh/events-feed/")!
    
    var events = [Event]()
    
    let validElements = ["title", "description", "ev:startdate"]
    var currentValue: String?
    var eventTitle: String?
    var eventDescription: String?
    var eventDate: NSDate?
    
    static var inDateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()
    
    func beginParsing() {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            
            guard let data = data else {
                print("Data not received")
                return
            }
            
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
            NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)
            
        }
        task.resume()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if validElements.contains(elementName) {
            currentValue = String()
        }
    }
    
    // found characters
    // if this is an element we care about, append those characters.
    // if currentValue is still nil, then do nothing.
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "title":
                eventTitle = currentValue
            case "description":
                eventDescription = currentValue
            case "ev:startdate":
                eventDate = EventParser.inDateFormatter.dateFromString(currentValue!)!
            case "item":
                
                // trim description string (remove whitespace from beginning and end)
                eventDescription = eventDescription!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                events += [Event(title: eventTitle!, description: eventDescription!, startDate: eventDate!)]
            
            default: break
        }
        currentValue = nil
    }
    
}