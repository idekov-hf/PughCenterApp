//
//  Constants.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 8/7/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

// MARK: - WordpressClient (Constants)
extension WordpressClient {
    
    struct URLs {
        
        static let ClubList = "https://www.colby.edu/pugh/wp-json/colby-rest/v0/acf-options?clubs=1"
    }
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.colby.edu"
        static let ApiPath = "/pugh/wp-json/colby-rest/v0/acf-options"
    }
    
    struct ParameterKeys {
        static let Clubs = "clubs"
    }
    
    struct ParameterValues {
        static let Show = "1"
    }
}