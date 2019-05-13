//
//  BaseTestCase.swift
//  Direction-SampleTests
//
//  Created by Shichimitoucarashi on 5/13/19.
//  Copyright © 2019 keisuke yamagishi. All rights reserved.
//

import Foundation

import XCTest
import GoogleMaps

class BaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        APIKEY = "AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4"
        GMSServices.provideAPIKey("AIzaSyC0hOi1H3H-GorTbUIG8Ttoy4jDua5Vcd4")
    }
}
