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

public var APIKEY: String = ""

public enum DirectionType: String {
    case driving
    case walking
    case bicycling
    case transit
}

public enum TransitMode: String {
    case bus
    case subway
    case train
    case tram
    case rail
}
// swiftlint:disable all
public class Direction: NSObject, URLSessionDataDelegate {

    let fromLocation: String?
    let toLocation: String?
    var altanative: String
    var type: DirectionType
    var transitMode: String?

    /*
     * member's value
     *
     */
    public var data: Data?
    public var response: HTTPURLResponse?
    public var dataTask: URLSessionDataTask!

    /*
     * Callback function
     * success Handler
     *
     */
    public typealias CompletionHandler = (_ route: Directions) -> Void
    public typealias FailuerHandler = (_ error: Error) -> Void

    public var completion: CompletionHandler?
    public var failuer: FailuerHandler?

    public convenience init(from: CLLocationCoordinate2D,
                            to: CLLocationCoordinate2D,
                            alternative: Bool = false,
                            mode: DirectionType = .walking,
                            transitMode: [TransitMode] = []) {
        let from = String(format: "%f,%f", from.latitude, from.longitude)
        let to = String(format: "%f,%f", to.latitude, to.longitude)
        self.init(from: from, to: to, alternative: alternative, mode: mode, transitMode: transitMode)
    }

    public init(from: String,
                to: String,
                alternative: Bool = false,
                mode: DirectionType = .walking,
                transitMode: [TransitMode] = []) {
        self.fromLocation = from
        self.toLocation = to
        self.altanative = alternative ? "true" : "false"
        self.type = mode
        self.transitMode = transitMode.toValue
    }

    public func calculation(completion: @escaping (_ route: Directions) -> Void,
                            failuer: @escaping (_ error: Error) -> Void) {

        self.completion = completion
        self.failuer = failuer

        var query: [String:String] = [sensor: "true",
                                      origin: self.toLocation!,
                                      destination: self.fromLocation!,
                                      mode: self.type.rawValue,
                                      alternatives: self.altanative,
                                      key: APIKEY]
        if self.type == .transit && !(self.transitMode?.isEmpty ?? false) {
            query[transit] = self.transitMode
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let request = Route.request(query) {
            let dataTask = session.dataTask(with: request)
            dataTask.resume()
        }else{
            failuer(NSError.create(domain: "URL Error",
                                   code: 10061,
                                   userInfo: ["LocalizedRecoverySuggestion": "URL is invalid, please check domain and URL and correct."]))
        }
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
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didCompleteWithError error: Error?) {

        /*
         * Responce status code 200
         */
        if self.response?.statusCode == 200 {
            do {
                if self.data != nil {
                    let direction = try JSONDecoder().decode(Directions.self, from: self.data!)
                    /*
                     * Success
                     */
                    if direction.status == "OK"
                        || direction.errorMessage != nil {
                        self.completion!(direction)
                    } else {// Error handling
                        let domain = "\(direction.errorMessage ?? "Nothing message")\nStatus: \(direction.status ?? "nothins status")"
                        let err = NSError(domain: domain, code: 10058)
                        self.failuer!(err)
                    }
                }
            } catch {
                print("Exception! json decode Error")
            }
        } else {//Error Handling
            var statusCode: String = "Nothing Responce"
            if self.response != nil {
                statusCode = (response?.statusCode.description)!
                let err = NSError(domain: "Failuer: responce code: \(statusCode)!", code: 10059)
                self.failuer!(err)
            } else if error != nil {
                self.failuer!(error!)
            }
        }
    }

    /*
     * get recive function
     *
     */
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if self.data == nil {
            self.data = data
        } else {
            self.data?.append(data)
        }
    }

    /*
     * get Http response
     *
     */
    public func urlSession(_ session: URLSession,
                           dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.response = response as? HTTPURLResponse
        completionHandler(.allow)
    }
}

/*
 * Display the route route on the map 😄
 */
public extension GMSMapView {

    func addDirection(routes: [Routes], color: UIColor = .blue) {
        for route in routes {
            self.addOverlay(path: route.overviewPolyline?.points ?? "", color: color)
        }
    }

    func addOverlay(path: String, color: UIColor = .blue) {
        let gmsPath: GMSPath = GMSPath(fromEncodedPath: path)!
        let line = GMSPolyline(path: gmsPath)
        line.strokeColor = color
        line.strokeWidth = 6.0
        line.map = self
    }
}
// swiftlint:enable all
