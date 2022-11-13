//
//  AppSettings.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Foundation

class AppSettings {
    
    static var shared: AppSettings = {
        return AppSettings()
    }()
    
    private init() {}
    
    // MARK: - Properties
    
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
    
}
