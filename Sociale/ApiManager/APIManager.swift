//
//  APIManager.swift
//  Sociale
//
//  Created by Guy Adler on 27/09/2023.
//

import Foundation
import UIKit
import Alamofire


enum ApiError : Error {
    case BadUrl(String)
    case RequestError(Error)
    case SocialeError(String)
    case AlamoFireError(AFError)
    case CorruptedData
    case EncodeError(Error)
    case ParsingError(Error)
}

enum FileType {
    case Video, Audio, Image
    
    func mimeType() -> String{
        switch self {
        case FileType.Video:
            return "video/mp4"
        case FileType.Audio:
            return "audio/wav"
        case FileType.Image:
            return "image/png"
        }
    }
    
    func ext() -> String{
        switch self {
        case FileType.Video:
            return "mp4"
        case FileType.Audio:
            return "wav"
        case FileType.Image:
            return "png"
        }
    }
    
}

class AsyncApiManager {
    
    static func authenticated_get<ResponseBody:Codable>(endpoint:String,
                                             token :String,
                                             responseBodyType: ResponseBody.Type) async throws -> ResponseBody {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.authenticated_get(endpoint: endpoint, token: token, responseBodyType: ResponseBody.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    static func post<RequestBody:Codable, ResponseBody:Codable>(endpoint:String,
                                                                data: RequestBody, responseBodyType: ResponseBody.Type) async throws -> ResponseBody {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.post(endpoint: endpoint, data: data, responseBodyType: responseBodyType) { result in
                continuation.resume(with: result)
            }
        }
    }
    
}

class APIManager {
    
    static func authenticated_get<ResponseBody:Codable>(endpoint:String,
                                                        token :String,
                                                        responseBodyType: ResponseBody.Type,
                                                        callback: @escaping (Result<ResponseBody, ApiError>) -> Void) {
        
        let urlString  = "http://localhost:8080/\(endpoint)"
        guard let url = URL(string:urlString) else {
            callback(.failure(.BadUrl("Url was bad \(urlString)")))
            return
        }
        var request = URLRequest(url: url)
        // @TODO : Change this to a cached userDefauls token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        request.httpMethod = "GET"
            
        URLSession.shared.dataTask(with: request) { data,_,err in
            guard let data = data else {
                callback(.failure(.CorruptedData))
                return
            }
            if let error = err {
                callback(.failure(.RequestError(error)))
                return
            }
            
            do {
                let data_object = try JSONDecoder().decode(responseBodyType.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(data_object))
                    }
                }
            catch {
                callback(.failure(.ParsingError(error)))
            }
         
        }.resume()
    }
    
    
    
    static func post<RequestBody:Codable, ResponseBody:Codable>(endpoint:String, 
                                                                data: RequestBody,
                                                                responseBodyType: ResponseBody.Type,
                                                                callback: @escaping (Result<ResponseBody, ApiError>) -> Void) {
        
        let urlString = "http://localhost:8080/\(endpoint)"
        guard let url = URL(string: urlString) else {
            callback(.failure(.BadUrl("Url was bad \(urlString)")))
            return
        }
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        request.httpMethod = "POST"
        
        if let token = AuthManager.instance.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try! JSONEncoder().encode(data)
  
            
        URLSession.shared.dataTask(with: request) { data,_,err in
            guard let data = data else {
                callback(.failure(.CorruptedData))
                return
            }

            do {
                let data_object = try JSONDecoder().decode(responseBodyType.self, from: data)
                DispatchQueue.main.async {
                    callback(.success(data_object))
                }
            } catch {
                callback(.failure(.ParsingError(error)))
        
            }
         
        }.resume()
        
    }
    
    
 
    
    static func postImage(data: Data,
                          postBody: PostBody,
                          fileType: FileType,
                          token:String,
                          callback: @escaping (Result<ServerResponse<User>, ApiError>) -> Void) {
    
        
        let urlString = "http://localhost:8080/user-uploads/upload-image"
        guard let url = URL(string: urlString) else {
            callback(.failure(.BadUrl("Url was bad \(urlString)")))
            return
        }
        var request = URLRequest(url: url)
        
        let postData = try! JSONEncoder().encode( postBody )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        let uuid = UUID().uuidString

        let imageName = "\(uuid).\(fileType.ext())"
       
        let uploadTask = Alamofire.AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(postData,
                                          withName: "postBody",
                                          mimeType: "application/json")
            multipartFormData.append(data,
                                     withName: "image",
                                     fileName: imageName,
                                     mimeType: fileType.mimeType())
        }, with: request)
        
        
        uploadTask.response { response in
        
            guard let data = response.data else {
                callback(.failure(.CorruptedData))
                return
            }
            
            if let error = response.error {
                callback(.failure(.AlamoFireError(error)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ServerResponse<User>.self, from: data)
                if let user = response.data {
                    callback(.success(response))
                }
            } catch  {
                callback(.failure(.ParsingError(error)))
            }
        }

        uploadTask.resume()
    }
    
    
    
    static func postProfileImage(data: Data,
                          token:String,
                          callback: @escaping (Result<ServerResponse<User>, ApiError>) -> Void) {
    
        
        let urlString = "http://localhost:8080/user-uploads/upload-profile-image"
        guard let url = URL(string: urlString) else {
            callback(.failure(.BadUrl("Url was bad \(urlString)")))
            return
        }
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        let uuid = UUID().uuidString

        let imageName = "profile_\(uuid).png"
       
        let uploadTask = Alamofire.AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data,
                                     withName: "image",
                                     fileName: imageName,
                                     mimeType: "image/png")
        }, with: request)
        
        
        uploadTask.response { response in
        
            guard let data = response.data else {
                callback(.failure(.CorruptedData))
                return
            }
            
            if let error = response.error {
                callback(.failure(.AlamoFireError(error)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ServerResponse<User>.self, from: data)
                if let user = response.data {
                    callback(.success(response))
                }
            } catch  {
                callback(.failure(.ParsingError(error)))
            }
        }

        uploadTask.resume()
    }


    
}
