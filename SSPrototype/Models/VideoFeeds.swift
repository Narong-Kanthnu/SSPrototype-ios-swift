//
//  VideoFeeds.swift
//  SSPrototype
//
//  Created by Narong Kanthanu on 23/10/2561 BE.
//  Copyright © 2561 Narong Kanthanu. All rights reserved.
//

import ObjectMapper

class VideoFeeds: NSObject, Mappable {
    
    var videoDescription: String?
    var sources: [String]?
    var subtitle = ""
    var thumb: URL?
    var title = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        videoDescription <- map["description"]
        sources <- map["sources"]
        subtitle <- map["subtitle"]
        thumb <- (map["thumb"], URLTransform(shouldEncodeURLString: false))
        title <- map["title"]
    }
    
    convenience init?(data: [String:Any]) {
        self.init(JSON: data)
    }
}
