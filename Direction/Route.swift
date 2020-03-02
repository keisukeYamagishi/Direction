//
//  RouteUrl.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/17.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import Foundation

class Route {

    static let directionApi = "https://maps.googleapis.com/maps/api/directions/json?"

    let query: String

    init (query: [String: String]) {
        self.query = query.encode(using: .utf8)
    }

    static func url(query: [String: String]) -> URL {
        return  Route(query: query).url
    }

    var url: URL {
        return NSURL(string: Route.directionApi + self.query)! as URL
    }
}

class RouteRequest {

    var request: URLRequest

    init(url: URL) {
        self.request = URLRequest(url: url)
        self.request.httpMethod = "GET"
        self.request.timeoutInterval = 60
    }
}
