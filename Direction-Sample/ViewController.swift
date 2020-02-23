//
//  ViewController.swift
//  Direction
//
//  Created by Shichimitoucarashi on 2017/12/15.
//  Copyright © 2017年 keisuke yamagishi. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate {

    var mapView:GMSMapView!
    var coordinates: [CLLocationCoordinate2D] = []
    var direction: Direction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: 37.384224917595063, longitude: -122.03266438096762, zoom: 13.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        view = self.mapView
        
        let direction = Direction(from:"37.384224917595063,-122.03266438096762",
                                  to: "37.352311950908444,-121.99342869222163",
                                  alternative: true)
        let fromMarker = CLLocationCoordinate2D(latitude: 37.384224917595063, longitude: -122.03266438096762)
        let toMarker = CLLocationCoordinate2D(latitude: 37.352311950908444, longitude: -121.99342869222163)
        coordinates.append(fromMarker)
        coordinates.append(toMarker)
        self.directionMarker(location: fromMarker)
        self.directionMarker(location: toMarker)
        
        direction.calculation(completion: {[weak self] route in
            print (route)
            
            for route in route.routes {
                self?.mapView.addDirection(path: (route?.overviewPolyline?.points)!)
            }
            
        }) { (error) in
            print (error)
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        if coordinates.count >= 2 {
            coordinates.removeAll()
            self.mapView.clear()
        }
        
        directionMarker(location: coordinate)
        coordinates.append(coordinate)
        
        if coordinates.count == 2 {
            
            self.direction = Direction(from: coordinates[0], to: coordinates[1], alternative: true, mode: .walking)
            
            direction.calculation(completion: {[weak self] route in
                for route in route.routes {
                    self?.mapView.addDirection(path: (route?.overviewPolyline?.points)!)
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

