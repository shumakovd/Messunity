//
//  UserML.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 15.11.2022.
//

import Foundation

class UserML {
    let username: String?
    let email: String?
    let number: String?
    
    let imageId: String?
    let imageURL: String?
    let imageData: String?
    
    init(username: String?, email: String?, number: String?, imageId: String?, imageURL: String?, imageData: String?) {
        self.username = username
        self.email = email
        self.number = number
        self.imageId = imageId
        self.imageURL = imageURL
        self.imageData = imageData
    }
     
}
