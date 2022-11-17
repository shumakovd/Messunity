//
//  DictionaryExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 16.11.2022.
//

import Foundation

extension Dictionary {
    
    func keysToString() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for (key, value) in self {
            dictionary["\(key)"] = value
        }
        return dictionary
    }
    
}
