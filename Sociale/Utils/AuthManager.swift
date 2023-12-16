//
//  TokenManager.swift
//  Sociale
//
//  Created by Guy Adler on 16/10/2023.
//

import Foundation

import UIKit

class AuthManager {
    
    fileprivate var token:Optional<String>
    
    fileprivate var user: Optional<User>
    
    static let instance = AuthManager()
    
    // retrieves the token
    func getToken() -> Optional<String> {
        if let token = token {
            return token
        }
        
        let user_defaults = UserDefaults.standard
        if let token = user_defaults.string(forKey: "token") {
            self.token = token
            return token
        }
        self.token = Optional.none
        return Optional.none
    }
    
    
    // saves the token in the user defaults
    // activate on sign-in,sign-up
    func saveToken(_ token: String) {
        let user_defaults = UserDefaults.standard
        self.token = token
        user_defaults.setValue(token, forKey: "token")
    }
    
    
    // removes the token from user default
    // activate on sign-out
    func removeToken() {
        let user_defaults = UserDefaults.standard
        self.token = Optional.none
        user_defaults.removeObject(forKey: "token")
    }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    func getUser() -> Optional<User> {
        return self.user
    }
    
    func getUserSlice() -> Optional<UserSlice> {
        return self.user?.toUserSlice()
    }
    
    private init () { token =  Optional.none; user = Optional.none }
}
