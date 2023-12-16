//
//  Comment.swift
//  Sociale
//
//  Created by Guy Adler on 27/11/2023.
//

import Foundation



struct UserSlice : Codable {
    var _id: String
    var name: String
    var email: String
    var image: String?
    var admin: Bool
}

struct Comment : Codable  {
    var _id: String // id of the comment
    var content: String
    var upload: String // id of the upload the comment was posted on
    var created_at: Double
    var user: UserSlice //  the user that posted the comment
    
    static func initWith(commentNoUser: CommentNoUser) -> Comment? {
        if let userSlice = AuthManager.instance.getUserSlice() {
            return Comment(_id: commentNoUser._id,
                           content: commentNoUser.content,
                           upload:commentNoUser.upload,
                           created_at: commentNoUser.created_at,
                           user: userSlice)
        }
        return nil
    }
}

struct CommentNoUser : Codable  {
    var _id: String // id of the comment
    var content: String
    var upload: String // id of the upload the comment was posted on
    var user: String //  the id of user that posted the comment
    var created_at: Double
}
