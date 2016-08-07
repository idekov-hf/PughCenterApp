//
//  WordpressClient.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 8/7/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

// MARK: - WordpressClient (Network Code)
class WordpressClient {
    
    // MARK: Shared Instance
    static var sharedInstance = WordpressClient()
    
    // MARK: Properties
    private let session = NSURLSession.sharedSession()
    
    // MARK: GET Request
    func taskForGETMethod(parameters: [String: AnyObject],  completionHandlerForGET: (result: AnyObject!, error: String?) -> Void) {
        
        let request = NSURLRequest(URL: urlFromParameters(parameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func forwardError(error: String) {
                print(error)
                completionHandlerForGET(result: nil, error: error)
            }
            
            // Check for error
            guard (error == nil) else {
                forwardError("There was an error: \(error)")
                return
            }
            
            // Check for successful 2xx status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                forwardError("Did not receive successful 2xx status code")
                return
            }
            
            // Unwrap data
            guard let data = data else {
                forwardError("Data not unwrapped successfully")
                return
            }
            
            // Parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                forwardError("Could not parse the data as JSON:\n\(data)")
                return
            }
            
            // Call the completion handler
            completionHandlerForGET(result: parsedResult, error: nil)
        }
        
        task.resume()
    }
    
    // MARK: Helper
    // Create a URL from parameters
    private func urlFromParameters(parameters: [String: AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
}