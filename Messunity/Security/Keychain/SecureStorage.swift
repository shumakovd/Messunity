//
//  SecureStorage.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Security
import Foundation

// MARK: - Secure Model

public struct Account {
    public var id: String
    public var number: String
    
    public init(id: String, number: String) {
        self.id = id
        self.number = number
    }
}

// MARK: - Secure Storage

public final class SecureStorage {
    
    // MARK: - Errors
    
    enum KeychainError: Error {
        case itemAlreadyExist
        case itemNotFound
        case errorStatus(String?)
        
        init(status: OSStatus) {
            switch status {
            case errSecDuplicateItem:
                self = .itemAlreadyExist
            case errSecItemNotFound:
                self = .itemNotFound
            default:
                let message = SecCopyErrorMessageString(status, nil) as String?
                self = .errorStatus(message)
            }
        }
    }
    
    // MARK: - Methods
    
    func addItem(query: [CFString: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)
        
        print("• Add Item: ", status)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    func findItem(query: [CFString: Any]) throws -> [CFString: Any]? {
        var query = query
        
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        
        var searchResult: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &searchResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
    
        if status != errSecSuccess {
            throw KeychainError(status: status)
        } else {
            return searchResult as? [CFString: Any]
        }
    }
    
    func updateItem(query: [CFString: Any], attributesToUpdate: [CFString: Any]) throws {
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    func deleteItem(query: [CFString: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    //
    
    class func logout() {
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}


// MARK: - Secure Storage in Action

public extension SecureStorage {
    
    func addAccount(_ account: Account, with label: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label
        query[kSecAttrAccount] = account.number
        query[kSecValueData] = account.id.data(using: .utf8)
        
        do {
            try addItem(query: query)
        } catch {
            return
        }
    }
    
    func updateAccount(_ account: Account, with label: String) {
        deleteAccount(with: label)
        addAccount(account, with: label)
    }
    
    func getAccount(with label: String) -> Account? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label
        
        var result: [CFString: Any]?
        
        do {
            result = try findItem(query: query)
        } catch {
            return nil
        }
        
        if let account = result?[kSecAttrAccount] as? String,
           let data = result?[kSecValueData] as? Data,
           let number = String(data: data, encoding: .utf8) {
            return Account(id: account, number: number)
        } else {
            return nil
        }
    }
    
    func deleteAccount(with label: String) {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrLabel] = label
                
        do {
            try deleteItem(query: query)
        } catch {
            return
        }
    }
}

// MARK: - @propertyWrapper Firebase Token

@propertyWrapper
public struct FirebaseAccount {
    private let key: String
    private let storage = SecureStorage()

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Account? {
        get {
            print("• _getAccount with ", key)
            return storage.getAccount(with: key)
        }
        nonmutating set {
            if let newValue {
                print("• _updateAccount with ", key, "value: ", newValue)
                storage.updateAccount(newValue, with: key)
            } else {
                print("• _deleteAccount with ", key)
                storage.deleteAccount(with: key)
            }
        }
    }
}
