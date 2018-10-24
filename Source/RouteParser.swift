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
    public var error_message:String?
    public var geocoded_waypoints:[GeocodedWaypoints?]?
    public var routes: [Routes?]
    public var status: String?
}

public struct GeocodedWaypoints:Codable {
    public var geocoder_status:String? = ""
    public var place_id:String? = ""
    public var types:[String?]? = []
}

public struct Routes: Codable {
    public var bounds :Position?
    public var copyrights:String?
    public var overview_polyline:Points?
    public var legs:[Legs?]
    public var summary:String?
    public var warnings:[String?]
}

public struct Legs:Codable{
    public var distance:Distancies?
    public var duration:Distancies?
    public var end_address:String?
    public var end_location:Coordinate?
    public var start_address:String?
    public var start_location:Coordinate?
    public var steps:[Step?]
//    public var traffic_speed_entry:[String?]
//    public var via_waypoint:[String?]
}

public struct Step:Codable{
    public var distance:Distancies?
    public var duration:Distancies?
    public var end_location:Coordinate?
    public var html_instructions:String?
    public var polyline:Polylines?
    public var start_location:Coordinate?
    public var travel_mode:String?
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
