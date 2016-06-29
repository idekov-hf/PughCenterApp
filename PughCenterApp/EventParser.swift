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
    
    override init() {
        if let dictionary = defaults.dictionaryForKey("linkDictionary") as? [String: String] {
            oldLinkDictionary = dictionary
        }
    }
    
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
                eventDate = DateFormatters.inDateFormatter.dateFromString(currentValue!)!
            case "link":
                eventLink = currentValue
            case "item":
                
                // trim description string (remove whitespace from beginning and end)
                eventDescription = eventDescription!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                events += [Event(title: eventTitle!, description: eventDescription!, startDate: eventDate!, link: eventLink!)]
                
                addLinkToDictionary(eventLink!)
            default: break
        }
        currentValue = nil
    }
    
    // Persist new dictionary
    func parserDidEndDocument(parser: NSXMLParser) {
        defaults.setObject(newLinkDictionary, forKey: "linkDictionary")
    }
    
    func addLinkToDictionary(eventLink: String) {
        newLinkDictionary[eventLink] = getButtonStateFromOldDictionary(eventLink)
        
    }
    
    func getButtonStateFromOldDictionary(eventLink: String) -> String {
        if let buttonState = oldLinkDictionary[eventLink] {
            return buttonState
        }
        return "RSVP"
    }
    
}