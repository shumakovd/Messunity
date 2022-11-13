//
//  FirebaseManager.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseManager {
    
    /// The static field that controls the access to the singleton instance.
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: FirebaseManager = {
            return FirebaseManager()
        }()
    
    private init() {}
    
    enum Result<T> {
        case success(T)
        case failure(String)
    }
    
    // MARK: - Properties -
    
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    // MARK: - Methods -
    
    
}


