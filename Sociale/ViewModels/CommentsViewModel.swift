//
//  CommentsViewModel.swift
//  Sociale
//
//  Created by Guy Adler on 16/12/2023.
//

import Foundation
import Combine

class CommentsViewModel {
    let upload : CurrentValueSubject<UploadWithUser, Never>

    init(upload: UploadWithUser) {
        self.upload = CurrentValueSubject<UploadWithUser, Never>(upload)
    }
    
    func post_comment(content: String)  {
        let updatedUpload = self.upload.value
        let comment = CommentDto(content: content)
            Task {
                do {
                    let newComment = try await SocialeAPI.post(
                        endpoint: "user-uploads/comment/\(updatedUpload._id)",
                        data: comment,
                        responseBodyType: CommentNoUser.self)
                    if let comment = Comment.initWith(commentNoUser: newComment) {
                            updatedUpload.comments.append(comment)
                        DispatchQueue.main.async {
                            self.upload.send(updatedUpload)
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
    }
}

