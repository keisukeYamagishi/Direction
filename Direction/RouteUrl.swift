//
//  RouteUrl.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/17.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import Foundation

class RouteUrl {

    let directionApi = "https://maps.googleapis.com/maps/api/directions/json?"
    
    let query: String!
    
    init (query: [String:String] ){
        self.query = query.encode(using: .utf8)
    }
    
    var url: URL {
        return NSURL(string: directionApi + self.query)! as URL
    }
}

class RouteRequest {
    
    var request: URLRequest!
    
    init(url: URL){
        self.request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
    }
    
}

