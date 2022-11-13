//
//  NetworkStatus.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Alamofire
import Foundation

class NetworkStatus {
    static let sharedInstance = NetworkStatus()

    private init() {}
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

