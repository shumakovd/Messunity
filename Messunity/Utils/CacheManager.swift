//
//  CacheManager.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 16.11.2022.
//

import Foundation

final class CacheManager {
     
    // MARK: - User Cache
    
    static func setUserData<T>(value: T, key: UserChildValues){
        let defaults = UserDefaults(suiteName: "user_key")
        defaults?.set(value, forKey: key.rawValue)
    }
    
    static func getUserData<T>(type: T.Type, forKey: UserChildValues) -> T?{
        let defaults = UserDefaults(suiteName: "user_key")
        let value = defaults?.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    static func removeUserData(key: UserChildValues){
        let defaults = UserDefaults(suiteName: "user_key")
        defaults?.removeObject(forKey: key.rawValue)
    }
    
    // MARK: - User Methods
    
    func getUserModel() -> UserML {
        let username = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_name)
        let email = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_email)
        let number = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_number)
        
        let imageId = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_imageId)
        let imageURL = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_imageUrl)
        let imageData = CacheManager.getUserData(type: String.self, forKey: UserChildValues.u_imageData)
                
        let model = UserML(username: username, email: email, number: number, imageId: imageId, imageURL: imageURL, imageData: imageData)
        
        return model
    }
    
    func saveUserModel(dictionary: [UserChildValues: Any]) {
        for each in dictionary {
            if each.value != nil {
                CacheManager.setUserData(value: each.value, key: each.key)
            }            
        }
    }
    
}
