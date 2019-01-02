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
let key = "key"
let alternatives = "alternatives"

let overView = "overview_polyline"
let routes = "routes"
let polyline = "polyline"
let points = "points"

public struct Directions:Codable {
    public var errorMessage:String?
    public var geocodedWaypoints:[GeocodedWaypoints?]?
    public var routes: [Routes?]
    public var status: String?
    
    enum DirectionsKey:String,CodingKey {
        case errorMessage = "error_message"
        case geocodedWaypoints = "geocoded_waypoints"
    }
}

public struct GeocodedWaypoints:Codable {
    public var geocoderStatus:String? = ""
    public var placeId:String? = ""
    public var types:[String?]? = []
    
    enum GeocodedWaypointsKey:String,CodingKey {
        case geocoderStatus = "geocoder_status"
        case placeId = "place_id"
    }
}

public struct Routes: Codable {
    public var bounds :Position?
    public var copyrights:String?
    public var overviewPolyline:Points?
    public var legs:[Legs?]
    public var summary:String?
    public var warnings:[String?]
    
    enum CodingKeys:String,CodingKey {
        case bounds = "bounds"
        case copyrights = "copyrights"
        case overviewPolyline = "overview_polyline"
        case legs = "legs"
        case summary = "summary"
        case warnings = "warnings"
    }
}

public struct Legs:Codable{
    public var distance:Distancies?
    public var duration:Distancies?
    public var endAddress:String?
    public var endLocation:Coordinate?
    public var startAddress:String?
    public var startLocation:Coordinate?
    public var steps:[Step?]
//    public var traffic_speed_entry:[String?]
//    public var via_waypoint:[String?]
    
    enum LegsKey:String,CodingKey {
        case endAddress = "end_address"
        case endLocation = "end_location"
        case startAddress = "start_address"
        case startLocation = "start_location"
    }
}

public struct Step:Codable{
    public var distance:Distancies?
    public var duration:Distancies?
    public var endLocation:Coordinate?
    public var htmlInstructions:String?
    public var polyline:Polylines?
    public var startLocation:Coordinate?
    public var travelMode:String?
    
    enum StepsKey:String,CodingKey {
        case endLocation = "end_location"
        case htmlInstructions = "html_instructions"
        case startLocation = "start_location"
        case travelMode = "travel_mode"
    }
}

public struct Distancies:Codable {
    public var text:String?
    public var value: Int?
}

public struct Position:Codable{
    public var northeast:Coordinate?
    public var southwest:Coordinate?
}

public struct Coordinate:Codable {
    public var lat: Double?
    public var lng: Double?
}

public struct Polylines:Codable{
    public var points:String?
}

public struct OverviewPolyline:Codable {
    public var points:Points?
}

public struct Points:Codable {
    public var points:String?
}
