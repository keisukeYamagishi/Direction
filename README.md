# Direction

[![](https://img.shields.io/apm/l/vim-mode.svg)](https://github.com/keisukeYamagishi/Direction/blob/master/LICENSE)
[![](https://img.shields.io/badge/Twitter-O--Liker%20Error-blue.svg)](https://twitter.com/O_Linker_Error)

## OverView

Direction for Google Map for iOS SDK

<img src="https://github.com/keisukeYamagishi/Direction/blob/master/IMG_3437.PNG" width="30%" height="30%">

It is a library that makes it easy to conduct route search with the Google map SDK for iOS.
When creating an instance, you can display the route by passing the latitude and longitude of the departure point, the latitude and longitude of the arrival point as an argument, and calling the instance method.

## Use it

***Via SSH***: For those who plan on regularly making direct commits, cloning over SSH may provide a better experience (which requires uploading SSH keys to GitHub):

```
$ git clone git@github.com:keisukeYamagishi/Direction.git
```
***Via https***: For those checking out sources as read-only, HTTPS works best:

```
$ git clone https://github.com/keisukeYamagishi/Direction.git
```
## Easy start

default map line width 0.6f
default map color #4682b4

get route!!!!

```

## Installation

### Cocoapods


[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate GMSDirection into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
vi ./Podfile 
```

If you do not have the google map SDK for iOS

```
target 'Target Name' do
  use_frameworks!
  pod 'Direction'
  # google map SDK for iOS
  pod 'GoogleMaps'
  pod 'GooglePlaces'
end
```
Then, run the following command:

```bash
$ pod setup
$ pod install
```

let direction = Direction(from:"35.6775602107869,139.692658446729",to: "35.707848364433,139.701456092298",mode: .walking)
direction.directionCompletion(handler: { (route) in
    self.polyLine(path: route.pattern[0])
}) { (error) in

}

func polyLine (path: String) {
        let gmsPath: GMSPath = GMSPath(fromEncodedPath: path)!
        let line = GMSPolyline(path: gmsPath)
        line.strokeColor = ColorUtil().HexColor(hex: "34AADC")
        line.strokeWidth = 6.0
        line.map = self.mapView
}

```
*too easy!!*

Please pass the first position and the goal of the position as parameter

get route
