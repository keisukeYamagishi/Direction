//
//  URLEncode.swift
//  swiftDemo
//
//  Created by shichimi on 2017/03/17.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

extension String{
    
    /*
     * PersentEncode
     */
    func urlEncode(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}

extension Dictionary {
    
    /*
     * encoded Dictionary's value
     *
     */
    func encode(using encoding: String.Encoding) -> String {
        var parts = [String]()
        
        for (key, value) in self {
            let keyString = "\(key)".urlEncode()
            let valueString = "\(value)".urlEncode(keyString == "status")
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }
        return parts.joined(separator: "&")
    }
}
