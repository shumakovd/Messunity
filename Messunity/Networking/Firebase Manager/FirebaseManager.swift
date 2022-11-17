//
//  FirebaseManager.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseRemoteConfig

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
    
    // MARK: - Dispatch Queue -
    
    let queue = DispatchQueue(label: "firebase.manager.com", attributes: .concurrent)
    
    // MARK: - Properties -
    
    private var remoteConfig: RemoteConfig!
        
    private let reference = Database.database(url: AppSettings.realtimeReference ?? "").reference()
    
    private var currentUserInstance: User? // Auth.auth().currentUser?
    
    // MARK: - Authentication Methods -
        
    func phoneAuthProvider(code: NumberCode, number: String, completion: @escaping (_ verificationID: String) -> Void) {
        Auth.auth().languageCode = code.rawValue
                       
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("• Error: ", error.localizedDescription)
                return
            }
                                    
            print("• Verification: ", verificationID ?? "")
            completion(verificationID ?? "")
        }
    }

    func signInWithPhoneAuthProvider(currentVerificationId: String, verificationCode: String, number: String, completion: @escaping (_ result: Bool) -> Void) {
        
        let users = reference.child("Users")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                completion(false)
                return
            }
            
            if let authResult = authResult {
                self.currentUserInstance = authResult.user
                
                users.child(authResult.user.uid).updateChildValues([
                    "u_name": "Username\(Int.random(in: 0...1000))",
                    "u_number": number])
                                
                completion(true)
            }
            
            completion(false)
        }
        
        users.removeAllObservers()
    }
    
    func signInWithEmailAddress(parameters: [UserChildValues: Any], password: String, completion: @escaping (_ result: Bool) -> Void) {
        
        let users = reference.child("Users")
        let email = parameters[.u_email] as? String ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                print(authError.description)
                completion(false)
                return
            }
                
            if let authResult = authResult {
                self.currentUserInstance = authResult.user
                
                users.child(authResult.user.uid).updateChildValues([
                    "u_name" : "Username\(Int.random(in: 0...1000))",
                    "u_email" : email])
                completion(true)
                return
            }
            
            completion(false)
        }
        
        users.removeAllObservers()
    }
    
    func isUserWithEmailAlreadyExist(email: String, completion: @escaping (_ result: Bool) -> Void) {
        let users = reference.child("Users")
        
        users.queryOrdered(byChild: "u_email").queryEqual(toValue: email).observe(.value, with: { snapshot in
            if snapshot.exists(){
                completion(false)
            } else {
                completion(true)
            }
        })

        users.removeAllObservers()
    }
    
    func isUserWithNumberAlreadyExist(number: String, completion: @escaping (_ result: Bool) -> Void) {
        let users = reference.child("Users")
        
        users.queryOrdered(byChild: "u_number").queryEqual(toValue: number).observe(.value, with: { snapshot in
            if snapshot.exists(){
                completion(false)
            } else {
                completion(true)
            }
        })

        users.removeAllObservers()
    }
    
    /*
     do {
       try Auth.auth().signOut()
     } catch let signOutError as NSError {
       print ("Error signing out: %@", signOutError)
     }
     */
    
    
    // MARK: - Database Methods -
    
    
    func updateUserData(parameters: [UserChildValues: Any], completion: @escaping (_ result: Bool) -> Void) {
        let users = reference.child("Users")
        let uid = currentUserInstance?.uid ?? ""
                        
        let parameters = parameters.keysToString()
        
        print("• Parameters: ", parameters)
        
        users.child(uid).updateChildValues(parameters) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completion(false)
                print("• Data could not be saved: \(error).")
            } else {
                completion(true)
                print("• Data saved successfully!")
            }
        }
        
        users.removeAllObservers()
    }
    
    func getUserData(_ completion: @escaping () -> Void) {
        let users = reference.child("Users")
        let uid = currentUserInstance?.uid ?? ""
        
        users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
                                    
            print("calue: ", value)
            completion()
            
        })
    }
    
    
    
    // MARK: - Remote Config
    
    func fetchConfig(_ completion: @escaping (_ result: Bool, _ config: RemoteConfig) -> Void) {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
        
        remoteConfig.configSettings = settings
        remoteConfig.fetch(withExpirationDuration: TimeInterval(10)) { status, error2 -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { [weak self] _, _ in
                    guard let self = self else { return }
                    completion(true, self.remoteConfig)
                }
            } else {
                completion(false, self.remoteConfig)
                print("Config not fetched")
                print("Error: \(error2?.localizedDescription ?? "No error available.")")
            }
        }
    }
        
    
    // MARK: - Storage Methods -
    
    func uploadImageToStorage(image: UIImage?, completion: @escaping (_ imageURL: URL) -> ()) {
        
        let storageRef = Storage.storage().reference(forURL:"gs://messunity.appspot.com")
        
        let uid = currentUserInstance?.uid ?? ""
        let userRef = storageRef.child("Users").child(uid).child("avatar")
        
        guard let imageSelected = image else {
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        queue.async {
            userRef.putData(imageData, metadata: metadata, completion:{(storageMetadata, error) in
                if  error != nil{
                    print(error?.localizedDescription as Any)
                    return
                }
                
                userRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString{
                        guard let imageURL = URL(string: metaImageUrl) else { return }
                                            
                        completion(imageURL)
                    }
                })
            })
        }
    }

    
    
}



