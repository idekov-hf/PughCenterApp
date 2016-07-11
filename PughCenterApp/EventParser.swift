//
//  EventParser.swift
//  NSXMLTest
//
//  Created by Iavor Dekov on 3/2/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

protocol EventParserDelegate: class {
    func didFinishParsing(sender: EventParser)
    func didParseEvent(event: Event)
}

class EventParser: NSObject, NSXMLParserDelegate {
    
    weak var delegate: EventParserDelegate?
    
//    let url = NSURL(string: "https://www.colby.edu/pugh/events-feed/")!
    let url = NSBundle.mainBundle().URLForResource("TestData", withExtension: "xml")!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var events = [Event]()
    
    var newLinkDictionary = [String: String]()
    var oldLinkDictionary = [String: String]()
    
    // Parsing variables
    let validElements = ["title", "description", "ev:startdate", "link"]
    var currentValue: String?
    var eventTitle: String?
    var eventDescription: String?
    var eventDate: NSDate?
    var eventLink: String?
    
    func beginParsing() {
        if let dictionary = defaults.objectForKey("linkDictionary") as? [String: String] {
            oldLinkDictionary = dictionary
        }
        
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
            
//            self.delegate?.didFinishParsing(self)
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
                eventDate = DateFormatters.inDateFormatter.dateFromString(currentValue!)!
            case "link":
                eventLink = currentValue
            case "item":
                
                // Trim description string (remove whitespace from beginning and end)
                eventDescription = eventDescription!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                // Set the buttonTitle
                let buttonTitle = getButtonTitleFromOldDictionary(eventLink!)
                
                // Add button title to the new dictionary
                newLinkDictionary[eventLink!] = buttonTitle
                
                let event = Event(title: eventTitle!, description: eventDescription!, startDate: eventDate!, link: eventLink!, buttonStatus: buttonTitle)
            
                delegate?.didParseEvent(event)
            
                // Add the event to the array of Event objects
//                events += [Event(title: eventTitle!, description: eventDescription!, startDate: eventDate!, link: eventLink!, buttonStatus: buttonTitle)]
            
            default: break
        }
        currentValue = nil
    }
    
    // Persist new dictionary once parsing has finished
    func parserDidEndDocument(parser: NSXMLParser) {
        defaults.setObject(newLinkDictionary, forKey: "linkDictionary")
    }
    
    // Obtain the button title from persistent dictionary; return default state otherwise
    func getButtonTitleFromOldDictionary(eventLink: String) -> String {
        if let buttonTitle = oldLinkDictionary[eventLink] {
            return buttonTitle
        }
        return "RSVP"
    }
    
}