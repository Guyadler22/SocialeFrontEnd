//
//  ServerResponse.swift
//  Sociale
//
//  Created by Guy Adler on 16/10/2023.
//

import Foundation

struct ServerResponse<T: Codable> : Codable {
    var message:String?
    var data: T?
}
