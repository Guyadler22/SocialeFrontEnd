//
//  FeedViewModel.swift
//  Sociale
//
//  Created by Guy Adler on 04/12/2023.
//

import Foundation
import Combine

class FeedViewModel {
    let uploads = CurrentValueSubject<[UploadWithUser], Never>([])
    

    func get_uploads()  {
        Task {
            if let token = AuthManager.instance.getToken() {
                do {
                    let all_uploads = try await SocialeAPI.authenticated_get(endpoint: "user-uploads",
                                                                             token: token,
                                                                             responseBodyType: [UploadWithUser].self)
                    DispatchQueue.main.async {
                        self.uploads.send(all_uploads)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

