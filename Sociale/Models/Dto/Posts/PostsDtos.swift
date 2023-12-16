//
//  Post.swift
//  Sociale
//
//  Created by Guy Adler on 21/11/2023.
//

import UIKit

enum UploadType {
    case Video(Data, UIImage?) //  VideoData, Image for prview
    case Image(Data) // ImageData
}

struct PostBody : Codable {
    var caption: String
    var is_video: Bool
}

struct PostDto {
    var uploadType: UploadType
    var body: PostBody
}

struct CommentDto: Codable {
    var content: String
}

