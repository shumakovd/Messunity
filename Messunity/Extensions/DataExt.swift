//
//  DataExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 15.11.2022.
//

import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
