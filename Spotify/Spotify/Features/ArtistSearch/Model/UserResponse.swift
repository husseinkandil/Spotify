//
//  UserResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 18/05/2022.
//

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
}

struct ImageResponse: Codable {
    let url: String?
    let height: Int?
    let width: Int?
}
