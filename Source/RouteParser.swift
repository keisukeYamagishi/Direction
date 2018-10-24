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
    var error_message:String?
    var geocoded_waypoints:[GeocodedWaypoints?]?
    var routes: [Routes?]
    var status: String?
}

public struct GeocodedWaypoints:Codable {
    var geocoder_status:String? = ""
    var place_id:String? = ""
    var types:[String?]? = []
}

public struct Routes: Codable {
    var bounds :Position?
    var copyrights:String?
    var overview_polyline:Points?
    var legs:[Legs?]
    var summary:String?
    var warnings:[String?]
}

public struct Legs:Codable{
    var distance:Distancies?
    var duration:Distancies?
    var end_address:String?
    var end_location:Coordinate?
    var start_address:String?
    var start_location:Coordinate?
    var steps:[Step?]
//    var traffic_speed_entry:[String?]
//    var via_waypoint:[String?]
}

public struct Step:Codable{
    var distance:Distancies?
    var duration:Distancies?
    var end_location:Coordinate?
    var html_instructions:String?
    var polyline:Polylines?
    var start_location:Coordinate?
    var travel_mode:String?
}

public struct Distancies:Codable {
    var text:String?
    var value: Int?
}

public struct Position:Codable{
    var northeast:Coordinate?
    var southwest:Coordinate?
}

public struct Coordinate:Codable {
    var lat: Double?
    var lng: Double?
}

public struct Polylines:Codable{
    var points:String?
}

public struct OverviewPolyline:Codable {
    var points:Points?
}

public struct Points:Codable {
    var points:String?
}
