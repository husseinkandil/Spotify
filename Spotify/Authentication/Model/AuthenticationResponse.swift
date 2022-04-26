//
//  AuthenticationResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 24/04/2022.
//

import Foundation

struct AuthenticationResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
