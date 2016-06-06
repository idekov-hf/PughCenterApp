//
//  Club.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 5/6/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import Foundation

class Club {
    
    var name: String
    var description: String
    var url: String
    var imageURL: String
    
    init(name: String, description: String, url: String, imageURL: String) {
        self.name = name
        self.description = description
        self.url = url
        self.imageURL = imageURL
    }
    
}