//
//  Enums.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit
import Foundation

let kMainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let kAuthStoryboard = UIStoryboard(name: "Auth", bundle: nil)

enum ViewControllerIDs {
    
    enum MainStoryboard {
        // static let kMainTabBarVC = "MainTabBarVC"
        static let kMainTabBarVC = "MainTabBarVC"
    }
    
    enum AuthStoryboard {
        static let kAuthVC = "AuthVC"
        static let kLoginVC = "LoginVC"
    }
}
