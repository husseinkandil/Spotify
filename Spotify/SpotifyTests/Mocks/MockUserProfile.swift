//
//  MockUserProfile.swift
//  SpotifyTests
//
//  Created by jaber on 10/06/2022.
//

import Foundation
@testable import Spotify

class MockUserProfile: UserProfileAPIClient {
    
    var shouldFail = false
    
    func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
        if shouldFail {
        completion(.failure("sorry"))
        } else {
        
        completion(.success(.init(country: "lb", display_name: "kandil", external_urls: nil, id: "123", images: [])))
        }
    }
}

extension String: Error {
    
}
