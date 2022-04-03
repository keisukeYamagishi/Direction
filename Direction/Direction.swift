//
//  Direction.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import CoreLocation
import Foundation

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
                            transitMode: [TransitMode] = [])
    {
        let from = String(format: "%f,%f", from.latitude, from.longitude)
        let to = String(format: "%f,%f", to.latitude, to.longitude)
        self.init(from: from,
                  to: to,
                  alternative: alternative,
                  mode: mode,
                  transitMode: transitMode)
    }

    public init(from: String,
                to: String,
                alternative: Bool = false,
                mode: DirectionType = .walking,
                transitMode: [TransitMode] = [])
    {
        fromLocation = from
        toLocation = to
        altanative = alternative ? "true" : "false"
        type = mode
        self.transitMode = transitMode.toValue
    }

    public func detectRoute(completion: @escaping (_ route: Directions) -> Void,
                            failuer: @escaping (_ error: Error) -> Void)
    {
        self.completion = completion
        self.failuer = failuer

        var query: [String: String] = [DirectionsKey.sensor: "true",
                                       DirectionsKey.origin: toLocation!,
                                       DirectionsKey.destination: fromLocation!,
                                       DirectionsKey.mode: type.rawValue,
                                       DirectionsKey.alternatives: altanative,
                                       DirectionsKey.key: APIKEY]
        if type == .transit,
           !(transitMode?.isEmpty ?? true)
        {
            query[DirectionsKey.transit] = transitMode
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let request = Route.request(query) {
            let dataTask = session.dataTask(with: request)
            dataTask.resume()
        } else {
            failuer(NSError(domain: DirectionError.Domain.URLInvalidError,
                            code: DirectionError.invalidURL.toInt,
                            userInfo: [DirectionError.UserInfo.Key.LocalizedRecoverySuggestion:
                                        DirectionError.UserInfo.Value.InvalidURL]))
        }
    }
}

/*
 * URLSessionDataDelegate
 */
public extension Direction {
    /*
     * Get Responce and Result
     *
     *
     */
    func urlSession(_: URLSession,
                    task _: URLSessionTask,
                    didCompleteWithError error: Error?)
    {
        /*
         * Responce status code 200
         */
        if let httpResponse = response {
            if httpResponse.statusCode == 200 {
                do {
                    if let unwrapData = data {
                        let direction = try JSONDecoder().decode(Directions.self, from: unwrapData)
                        /*
                         * Success
                         */
                        if direction.status == "OK",
                           direction.errorMessage == nil
                        {
                            completion?(direction)
                        } else { // Error handling
                            let errorMessage = "\(direction.errorMessage ?? "Nothing message")\nStatus: \(direction.status ?? "nothins status")"
                            let err = NSError(domain: DirectionError.Domain.GoogleDirectionApiError,
                                              code: DirectionError.apiError.toInt,
                                              userInfo: [DirectionError.UserInfo.Key.LocalizedRecoverySuggestion:
                                                  errorMessage])
                            failuer?(err)
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let err = NSError(domain: DirectionError.Domain.HttpResponseError,
                                  code: DirectionError.invalidStatusCode.toInt,
                                  userInfo: [DirectionError.UserInfo.Key.LocalizedRecoverySuggestion:
                                      DirectionError.UserInfo.Value.InvalidHttpStatusCode])
                failuer?(err)
            }
        } else if let unwrapError = error {
            failuer?(unwrapError)
        }
    }

    /*
     * get recive function
     *
     */
    func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
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
    func urlSession(_: URLSession,
                    dataTask _: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        self.response = response as? HTTPURLResponse
        completionHandler(.allow)
    }
}

// swiftlint:enable all
