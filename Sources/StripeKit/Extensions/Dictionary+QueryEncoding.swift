//
//  Dictionary+QueryEncoding.swift
//
//
//  Created by Andrew Edwards on 4/11/20.
//

import Foundation

extension Dictionary where Key == String {
    var queryParameters: String {
        // A quick implementation of URLEncodedFormSerializer that includes indices in array key-paths
        // -> `items[0][plan]=...` instead of `items[][plan]=...`
        return Dictionary.queryComponents(keyPath: [], self).map { keyPath, value in
            "\(keyPath.queryKeyPercentEncoded)=\(value.queryValuePercentEncoded)"
        }.joined(separator: "&")
    }

    private static func queryComponents(keyPath: [String], _ value: Any) -> [([String], String)] {
        if let dictionary = value as? [String: Any] {
            return dictionary.flatMap { key, value in
                queryComponents(keyPath: keyPath + [key], value)
            }
        } else if let array = value as? [Any] {
            return array.enumerated().flatMap { idx, value in
                queryComponents(keyPath: keyPath + ["\(idx)"], value)
            }
        } else {
            return [(keyPath, "\(value)")]
        }
    }
}

extension CharacterSet {
    fileprivate static let queryComponentAllowed: CharacterSet = {
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.remove("&")
        characterSet.remove("+")
        return characterSet
    }()
}

extension Sequence where Element == String {
    fileprivate var queryKeyPercentEncoded: String {
        return enumerated().map { idx, key in
            let encodedKey = key.queryValuePercentEncoded
            return idx == 0 ? encodedKey : "[\(encodedKey)]"
        }.joined()
    }
}

extension String {
    fileprivate var queryValuePercentEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .queryComponentAllowed) ?? ""
    }
}
