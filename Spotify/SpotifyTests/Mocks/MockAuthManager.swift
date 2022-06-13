//
//  MockAuthManager.swift
//  SpotifyTests
//
//  Created by jaber on 10/06/2022.
//

import Foundation
@testable import Spotify

class MockAuthManager: AuthenticationManagerProtocol {
    var signinURL: URL? = URL(string: "ww.apple.com")
    
    var isSignedIn: Bool = false
    
    var codetest: String?
    
    func generateToken(code: String, completion: @escaping (Bool) -> Void) {
        self.codetest = code
        completion(true)
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func validateToke(completion: @escaping (String) -> Void) {
        completion("true")
    }
    
    func cacheToken(result: AuthenticationResponse) {
        
    }
    
    func signout(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func saveUser(user: UserProfile) {
        
    }
    
    func clearUser() {
        
    }
    
    func getUser() -> UserProfile? {
        return nil
    }
    
    
}
