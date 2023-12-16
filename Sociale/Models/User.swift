//
//  User.swift
//  Sociale
//
//  Created by Guy Adler on 16/10/2023.
//

import Foundation
struct User : Codable {
    var _id:String
    var email:String
    var name:String
    var image: String?
    var password:String
    var admin: Bool
    var uploads: [Upload]
    var birthday:String
    
    
    func toUserSlice() -> UserSlice {
        return UserSlice(_id: self._id, name: self.name, email: self.email, image: self.image, admin: self.admin)
    }
}
