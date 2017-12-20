//
//  ColorUtil.swift
//  Breris
//
//  Created by shichimi on 2017/09/28.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import UIKit

class ColorUtil {
    
    init() {}
    
    var colorNumbner: Int = 0
    
    public func Hex(hex: String) -> Int {
        return Int(hex, radix: 16) ?? 0
    }
    
    public func gradient (start: String, end: String) -> CAGradientLayer {
        let topColor = ColorUtil().HexColor(hex: start)
        
        let bottomColor = ColorUtil().HexColor(hex: end)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        
        return gradientLayer
    }
    
    public func HexColor(hex: String) -> UIColor{
        
        var hexCou = 0
        var redStr: String = ""
        var greenStr: String = ""
        var blueStr: String = ""
        
        for str in hex.characters {
            
            if ( hexCou >= 0 && hexCou < 2 ){
                redStr.append(str)
            }else if ( hexCou >= 2 && hexCou < 4 ){
                greenStr.append(str)
            }else if ( hexCou >= 4 && hexCou < 6 ) {
                blueStr.append(str)
            }
            hexCou+=1
        }
        return UIColor(red: CGFloat(self.Hex(hex: redStr))/255.0,
                       green: CGFloat(self.Hex(hex: greenStr))/255.0,
                       blue: CGFloat(self.Hex(hex: blueStr))/255.0,
                       alpha: 1)
    }
}
