//
//  Extension.swift
//  Direction-Sample
//
//  Created by Shichimitoucarashi on 2020/03/02.
//  Copyright © 2020 keisuke yamagishi. All rights reserved.
//

import Foundation

extension String {

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

extension Directions {
    func error(code: Int) -> Error {
        let domain = "\(self.errorMessage ?? "Nothing message")\nStatus: \(self.status ?? "nothins status")"
        let err = NSError(domain: domain, code: code)
        return err
    }
}
