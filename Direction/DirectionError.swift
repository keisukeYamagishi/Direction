//
//  DirectionError.swift
//  Direction-Sample
//
//  Created by keisuke yamagishi on 2022/04/03.
//  Copyright © 2022 keisuke yamagishi. All rights reserved.
//

import Foundation

enum DirectionError {
    case invalidURL
    case apiError
    case invalidStatusCode

    enum Domain {
        static let HttpResponseError = "Http Response Header StatusCodeInvalid"
        static let URLInvalidError = "URL is Invalid Error"
        static let GoogleDirectionApiError = "GoogleDirectionApiError"
    }

    enum UserInfo {
        enum Key {
            static let LocalizedRecoverySuggestion = "LocalizedRecoverySuggestion"
        }

        enum Value {
            static let InvalidURL = "URL is invalid, please check domain and URL and correct."
            static let InvalidHttpStatusCode = "The status code in the Http response header is invalid, check the error message."
        }
    }
}

extension DirectionError {
    var toInt: Int {
        switch self {
        case .invalidURL:
            return 10061
        case .apiError:
            return 10058
        case .invalidStatusCode:
            return 10060
        }
    }
}
