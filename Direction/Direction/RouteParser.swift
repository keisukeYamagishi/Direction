//
//  RouteParser.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/17.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import Foundation

let sensor = "sensor"
let origin = "origin"
let destination = "destination"
let mode = "mode"

let overView = "overview_polyline"
let routes = "routes"
let polyline = "polyline"
let points = "points"


struct Route {
    var json: [String: String] = [:]
    var pattern: [String] = []
}

class RouteParser {
    
    var route: Route = Route(json: [:], pattern: [])
    
    var json:Any?
    
    init(json: Any) {
        self.json = json
    }
    
    var parse: Route {
        return self.routeParser(json: self.json ?? AnyClass.self)
    }
    
    func routeParser (json: Any) -> Route{
        let apiData: Dictionary<String,Any> = json as! Dictionary<String, Any>
        for (key, value) in apiData {
            if key == routes {
                let routes: [Any] = value as! [Any]
                for route: Dictionary<String,Any> in routes as! [Dictionary<String,Any>]{
                    var line: Dictionary<String,Any> = route[overView] as! Dictionary<String, Any>
                    self.route.pattern.append(line[points] as! String)
                }
            }
        }
        return self.route
    }
}
