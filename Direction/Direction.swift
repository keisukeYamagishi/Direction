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
    var alternative: String
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
    public typealias FailureHandler = (_ error: Error) -> Void

    public var completion: CompletionHandler?
    public var failure: FailureHandler?

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
        self.alternative = alternative ? "true" : "false"
        type = mode
        self.transitMode = transitMode.toValue
    }

    public func detectRoute(completion: @escaping (_ route: Directions) -> Void,
                            failure: @escaping (_ error: Error) -> Void)
    {
        self.completion = completion
        self.failure = failure

        var query: [String: String] = [DirectionsKey.sensor: "true",
                                       DirectionsKey.origin: toLocation!,
                                       DirectionsKey.destination: fromLocation!,
                                       DirectionsKey.mode: type.rawValue,
                                       DirectionsKey.alternatives: alternative,
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
            failure(NSError(domain: DirectionError.Domain.URLInvalidError,
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
     * Get Response and Result
     *
     *
     */
    func urlSession(_: URLSession,
                    task _: URLSessionTask,
                    didCompleteWithError error: Error?)
    {
        /*
         * Response status code 200
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
                            let errorMessage = "\(direction.errorMessage ?? "Nothing message")\nStatus: \(direction.status ?? "nothing status")"
                            let err = NSError(domain: DirectionError.Domain.GoogleDirectionApiError,
                                              code: DirectionError.apiError.toInt,
                                              userInfo: [DirectionError.UserInfo.Key.LocalizedRecoverySuggestion:
                                                  errorMessage])
                            failure?(err)
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
                failure?(err)
            }
        } else if let unwrapError = error {
            failure?(unwrapError)
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
