//
//  AppSettings.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit
import Foundation

class AppSettings {
    
    static var shared: AppSettings = {
        return AppSettings()
    }()
    
    private init() {}
    
    // MARK: - Properties
    
    var user: UserML?            
    
    static var realtimeReference: String?
    
    // MARK: - Environment
    
    // FIXME: - For add new environment in future. dev, stage
    static var env: String = "test"
    
    static var serverUrl: URL {
        switch env {
        case "test":
            return URL(string: "http://api.evp.lt/")!
        default:
            return URL(string: "http://api.evp.lt/")!
        }
    }
    
    // MARK: - Methods
    
    func updateUserInformation() {
        // FIXME: - get user info from keychain and show main board or auth board
        
        //@FirebaseAccount("account")
        //var account: Account?
        
        // Use fot FaceId or TouchId and save into keychain
        // let number = numberTextField.text ?? ""
        //account = Account(id: "123", number: number)
        
        getUserFromCache()
        fetchRemoteConfigData()
        
    }
    
    func fetchRemoteConfigData() {
        FirebaseManager.shared.fetchConfig({ status, config in
            if status {
                let reference = config.configValue(forKey: "RealtimeDatabase")
                AppSettings.realtimeReference = reference.stringValue
            }
        })
    }
    
    
    // MARK: - Authentication Methods
    
    static func stanOfApplication() {
        if UserDefaults.standard.getAuthenticationStatus() ?? false {
            mainVC()
        } else {
            authVC()
        }        
    }
    
    static func mainVC() {
        
        var rootVC: UIViewController?
        UserDefaults.standard.setAuthenticationStatus(true)
        rootVC = kMainStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.MainStoryboard.kMainTabBarVC) as? MainTabBarVC
        APP_DELEGATE.window?.rootViewController = rootVC
    }
        
    static func authVC() {
        var rootVC: UIViewController?
        UserDefaults.standard.setAuthenticationStatus(false)
        rootVC = kAuthStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.AuthStoryboard.kAuthVC) as? AuthVC
        APP_DELEGATE.window?.rootViewController = rootVC
    }
    
    // MARK: - -
    
    func getUserFromCache() {
        user = CacheManager().getUserModel()
        print("• USER.name", user?.username)
        print("• USER.imageURL", user?.imageURL)
    }
    
    
    // MARK: -
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func getPasswordValidation(_ password: String) -> [String] {
        var errors: [String] = []
        
        if(password.count < 8){
            errors.append("Min 8 characters total")
        }
        // FIXME: - Include before publishing to the App Store
        /*
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)){
            errors.append("Least one lowercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)){
            errors.append("Least one uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)){
            errors.append("Least one digit")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: password)){
            errors.append("Least one symbol")
        }
        */
        return errors
    }
}
