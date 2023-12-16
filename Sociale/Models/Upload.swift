//
//  Upload.swift
//  Sociale
//
//  Created by Guy Adler on 21/11/2023.
//

import Foundation

enum UploadCodingKeys : String, CodingKey {
    case user = "user"
}
class Upload : Codable {
    var _id: String
    var uploadUrl: String
    var previewUrl: String?
    var caption: String
    var tags: [String]?
    var is_video: Bool
    var comments: [Comment]
    
    var likes: [UserSlice]
    init(_id: String, uploadUrl: String, caption: String, is_video: Bool, comments: [Comment], likes: [UserSlice]) {
           self._id = _id
           self.uploadUrl = uploadUrl
           self.previewUrl = nil // Assuming previewUrl is not provided in this initializer
           self.caption = caption
           self.tags = nil // Assuming tags are not provided in this initializer
           self.is_video = is_video
           self.comments = comments
           self.likes = likes
    }    

}
class UploadNoUser : Upload {
    var user: String


    init(_id: String, uploadUrl: String, caption: String, is_video: Bool, comments: [Comment], likes: [UserSlice], user:String) {
        self.user = user
        super.init(_id:_id,
                   uploadUrl:uploadUrl,
                   caption:caption,
                   is_video:is_video,
                   comments:comments,
                   likes:likes)
   
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UploadCodingKeys.self)
        user = try container.decode(String.self, forKey: UploadCodingKeys.user)
        try super.init(from: decoder)
    }
    
}

class UploadWithUser : Upload {
    var user: UserSlice
    init(_id: String, uploadUrl: String, caption: String, is_video: Bool, comments: [Comment], likes: [UserSlice], user:UserSlice) {
        self.user = user
        super.init(_id:_id,
                   uploadUrl:uploadUrl,
                   caption:caption,
                   is_video:is_video,
                   comments:comments,
                   likes:likes)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UploadCodingKeys.self)
        user = try container.decode(UserSlice.self, forKey: UploadCodingKeys.user)
        try super.init(from: decoder)
    }
}

