//
//  Direction.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import Foundation
import CoreLocation

public enum DirectionType: String {
    case driving = "driving"
    case walking = "walking"
    case bicycling = "bicycling"
}

class Direction {
    
    let fromLocation: String?
    let toLocation: String?
    var type: DirectionType?
    
    convenience init(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, mode: DirectionType) {
        let from = String(format: "%f,%f",from.latitude,from.longitude)
        let to = String(format: "%f,%f",to.latitude,to.longitude)
        self.init(from: from, to: to, mode: mode)
    }
    
    init(from: String, to: String, mode: DirectionType) {
        self.fromLocation = from
        self.toLocation = to
        self.type = mode
    }
    
    func directionCompletion(handler: @escaping (_ route: Route) -> Void,
                             failuer: @escaping (_ error: String) -> Void) {
        
        if self.type == nil {
            self.type = .walking
        }
        
        let query: [String:String] = [sensor:"true",
                                      origin: self.toLocation!,
                                      destination: self.fromLocation!,
                                      mode: self.type!.rawValue]
        
        let url = RouteUrl(query: query).url
        print (url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: RouteRequest(url: url).request, completionHandler: {
            (data, resp, err) in
            do {
                guard let json: Any = try JSONSerialization.jsonObject(with: data!,
                                                                       options: .allowFragments) else {
                                                                        failuer("not responce")
                                                                        return
                                                                        
                }
                let route: Route = RouteParser(json: json).parse
                handler(route)
            }catch{
                failuer("exception!")
            }
        })
        dataTask.resume()
    }
}

