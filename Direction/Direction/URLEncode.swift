//
//  URLEncode.swift
//  swiftDemo
//
//  Created by shichimi on 2017/03/17.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

class URLEncode : NSObject {
    
    let Utf8: String.Encoding = .utf8
}

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
    
    /*
     * Dictionary Converts a value to a string.
     * key=value&key=value
     * {
     *   key : value,
     *   key : value
     * }
     *
     */
    var parameters: Dictionary<String, String> {
        
        var parameters = Dictionary<String, String>()
        
        let scanner = Scanner(string: self)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanString("=", into: nil)
            
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanString("&", into: nil)
            
            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        return parameters
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
