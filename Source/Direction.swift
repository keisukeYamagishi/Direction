//
//  Direction.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

public var APIKEY:String = ""

public enum DirectionType: String {
    case driving = "driving"
    case walking = "walking"
    case bicycling = "bicycling"
}

public class Direction {
    
    let fromLocation: String?
    let toLocation: String?
    var type: DirectionType?
    public var route: Route?
    
    public convenience init(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, mode: DirectionType) {
        let from = String(format: "%f,%f",from.latitude,from.longitude)
        let to = String(format: "%f,%f",to.latitude,to.longitude)
        self.init(from: from, to: to, mode: mode)
    }
    
    public init(from: String, to: String, mode: DirectionType) {
        self.fromLocation = from
        self.toLocation = to
        self.type = mode
    }
    
    open func directionCompletion(handler: @escaping (_ route: Route) -> Void,
                                  failuer: @escaping (_ error: String) -> Void) {
        
        if self.type == nil {
            self.type = .walking
        }
        
        let query: [String:String] = [sensor:"true",
                                      origin: self.toLocation!,
                                      destination: self.fromLocation!,
                                      mode: self.type!.rawValue,
                                      key: APIKEY]
        
        let url = RouteUrl(query: query).url
        print (url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let dataTask = session.dataTask(with: RouteRequest(url: url).request, completionHandler: {
            (data, resp, err) in
            do {
                let json: Any = try JSONSerialization.jsonObject(with: data!,
                                                                 options: .allowFragments)
                
                print (json)
                
                DispatchQueue.main.sync {
                    self.route = RouteParser(json: json).parse
                    handler(self.route!)
                }
            }catch{
                failuer("exception!")
            }
        })
        dataTask.resume()
    }
}

public extension GMSMapView {
    
    public func addDirection (path: String, color: UIColor = .blue) {
        let gmsPath: GMSPath = GMSPath(fromEncodedPath: path)!
        let line = GMSPolyline(path: gmsPath)
        line.strokeColor = color
        line.strokeWidth = 6.0
        line.map = self
    }
}

