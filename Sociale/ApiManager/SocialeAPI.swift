//
//  SocialeAPI.swift
//  Sociale
//
//  Created by Guy Adler on 06/11/2023.
//

import Foundation



class SocialeAPI {
    
    static func authenticated_get<T:Codable>(endpoint:String,
                                             token :String,
                                             responseBodyType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.authenticated_get(endpoint: endpoint, token: token, responseBodyType: ServerResponse<T>.self) { result in
                switch result {
                case .success(let serverResponse):
                    if let data = serverResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApiError.SocialeError(serverResponse.message!))
                    }
                case .failure(let apiError):
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
    
    
    static func post<RequestBody:Codable, T:Codable>(endpoint:String,
                                                     data: RequestBody, 
                                                     responseBodyType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.post(endpoint: endpoint, data: data, responseBodyType: ServerResponse<T>.self) { result in
                switch result {
                case .success(let serverResponse):
                    if let data = serverResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApiError.SocialeError(serverResponse.message!))
                    }
                case .failure(let apiError):
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
    
    
    static func postImage(data: Data,
                          postBody: PostBody,
                          fileType: FileType,
                          token:String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.postImage(data: data, postBody :postBody, fileType: fileType, token: token) { result in
                switch result {
                case .success(let serverResponse):
                    if let data = serverResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApiError.SocialeError(serverResponse.message!))
                    }
                case .failure(let apiError):
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
    
    static func postProfileImage(data: Data,

                          token:String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.postProfileImage(data: data, token: token) { result in
                switch result {
                case .success(let serverResponse):
                    if let data = serverResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApiError.SocialeError(serverResponse.message!))
                    }
                case .failure(let apiError):
                    continuation.resume(throwing: apiError)
                }
            }
        }
    }
    
}
