//
//  DirectionType+.swift
//  Direction-Sample
//
//  Created by Shichimitoucarashi on 2020/02/23.
//  Copyright © 2020 keisuke yamagishi. All rights reserved.
//

import Foundation

extension Array where Element == TransitMode {
    var toValue: String {
        return map { $0.rawValue }.joined(separator: "|")
    }
}
