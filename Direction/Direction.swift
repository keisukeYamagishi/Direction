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

public class Direction: NSObject, URLSessionDataDelegate {
    
    let fromLocation: String?
    let toLocation: String?
    var altanative:String
    var type: DirectionType
    
    /*
     * member's value
     *
     */
    public var data: Data = Data()
    public var response: HTTPURLResponse?
    public var dataTask: URLSessionDataTask!
    
    /*
     * Callback function
     * success Handler
     *
     */
    public typealias completionHandler = (_ route: Directions) -> Void
    public typealias failuerHandler = (_ error: Error) -> Void
    
    public var completion: completionHandler?
    public var failuer: failuerHandler?
    
    public convenience init(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, alternative:Bool = false,  mode: DirectionType = .walking) {
        let from = String(format: "%f,%f",from.latitude,from.longitude)
        let to = String(format: "%f,%f",to.latitude,to.longitude)
        self.init(from: from, to: to,alternative: alternative, mode: mode)
    }
    
    public init(from: String, to: String,alternative:Bool = false, mode: DirectionType = .walking) {
        self.fromLocation = from
        self.toLocation = to
        self.altanative = alternative ? "true" : "false"
        self.type = mode
    }
    
    open func directionCompletion(handler: @escaping (_ route: Directions) -> Void,
                                  failuer: @escaping (_ error: Error) -> Void) {
        
        self.completion = handler
        self.failuer = failuer
        
        let query: [String:String] = [sensor:"true",
                                      origin: self.toLocation!,
                                      destination: self.fromLocation!,
                                      mode: self.type.rawValue,
                                      alternatives:self.altanative,
                                      key: APIKEY]
        
        let url = RouteUrl(query: query).url
        
        print ("Google Direction API URL: \(url)")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let dataTask = session.dataTask(with:RouteRequest(url: url).request)
        dataTask.resume()
    }
}

/*
 * URLSessionDataDelegate
 */
extension Direction {
    
    /*
     * Get Responce and Result
     *
     *
     */
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        /*
         * Responce status code 200
         */
        if self.response?.statusCode == 200 {
            
            let direction = try! JSONDecoder().decode(Directions.self, from: self.data)
            
            /*
             * Success
             */
            if  direction.status == "OK"
                || direction.errorMessage != nil {
                self.completion!(direction)
            }else{// Error handling
                let err = NSError(domain: "\(direction.errorMessage ?? "Nothing message")\nStatus: \(direction.status ?? "nothins status")", code: 10058)
                self.failuer!(err)
            }
        }else{//Error Handling
            var statusCode:String = "Nothing Responce"
            if self.response != nil {
                statusCode = (response?.statusCode.description)!
                let err = NSError(domain: "Failuer: responce code: \(statusCode)!", code: 10059)
                self.failuer!(err)
            }else if error != nil {
                self.failuer!(error!)
            }else{
                let err = NSError(domain: "Unknow Error", code: 10060)
                self.failuer!(err)
            }
        }
    }
    
    /*
     * get recive function
     *
     */
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        self.data.append(data)
        
        guard !data.isEmpty else { return }
    }
    
    /*
     * get Http response
     *
     */
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response as? HTTPURLResponse
        completionHandler(.allow)
    }
}

/*
 * Display the route route on the map 😄
 */
public extension GMSMapView {
    
    func addDirection (path: String, color: UIColor = .blue) {
        let gmsPath: GMSPath = GMSPath(fromEncodedPath: path)!
        let line = GMSPolyline(path: gmsPath)
        line.strokeColor = color
        line.strokeWidth = 6.0
        line.map = self
    }
}

