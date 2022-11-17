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
let kChatStoryboard = UIStoryboard(name: "Chat", bundle: nil)

enum ViewControllerIDs {
    
    enum MainStoryboard {
        // static let kMainTabBarVC = "MainTabBarVC"
        static let kMainTabBarVC = "MainTabBarVC"
    }
    
    enum AuthStoryboard {
        static let kAuthVC = "AuthVC"
        static let kLoginVC = "LoginVC"
        
        static let kCodeVC = "CodeVC"
        static let kCreateUserVC = "CreateUserVC"
    }
    
    enum ChatStoryboard {
        static let kChatListVC = "ChatListVC"
    }
}

enum AuthState {
    case withNumber, withEmail
}

enum NumberCode: String, CaseIterable {
    case en, ua    
}

enum UserChildValues: String, CaseIterable {
    case u_name
    case u_email
    case u_number
    case u_imageId
    case u_imageUrl
    case u_imageData
}
