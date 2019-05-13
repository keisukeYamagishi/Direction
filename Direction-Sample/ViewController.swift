//
//  ViewController.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import UIKit
import GoogleMaps
//import Direction

class ViewController: UIViewController, GMSMapViewDelegate {

    var mapView:GMSMapView!
    var coordinates: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 35.690144, longitude: 139.70004, zoom: 14.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        view = self.mapView
        
        let direction = Direction(from:"35.6775602107869,139.692658446729",to: "35.707848364433,139.701456092298")
        let fromMarker = CLLocationCoordinate2D(latitude:35.6775602107869, longitude:139.692658446729)
        let toMarker = CLLocationCoordinate2D(latitude:35.707848364433, longitude:139.701456092298)
        coordinates.append(fromMarker)
        coordinates.append(toMarker)
        self.directionMarker(location: fromMarker)
        self.directionMarker(location: toMarker)
        
        direction.directionCompletion(handler: { (route) in
            print (route)
            for route in route.routes {
                self.mapView.addDirection(path: (route?.overviewPolyline?.points)!)
            }
            
        }) { (error) in
            print (error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if coordinates.count >= 2 {
            coordinates.removeAll()
            self.mapView.clear()
        }
        
        directionMarker(location: coordinate)
        coordinates.append(coordinate)
        
        if coordinates.count == 2 {
            
            let direction = Direction(from: coordinates[0], to: coordinates[1], alternative: true, mode: .walking)
            
            direction.directionCompletion(handler: { (route) in
                for route in route.routes {
                    self.mapView.addDirection(path: (route?.overviewPolyline?.points)!)
                }
            }) { (error) in
                print (error)
            }
        }
    }
    
    func directionMarker (location: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = "start Direction"
        marker.snippet = "Hi! What's up!"
        marker.map = mapView
    }
}

