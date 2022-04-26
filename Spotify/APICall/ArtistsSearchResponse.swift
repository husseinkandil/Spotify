//
//  ArtistsSearchResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 25/04/2022.
//

import UIKit

struct ArtistsSearchResponse: Codable {
    let artists: ArtistsResponse?
}

struct ArtistsResponse: Codable {
    let href: String?
    var items: [Artist]
}

struct Artist: Codable {
    var images: [ImageResponse]?
    let name: String?
    let id: String?
    let popularity: Int?
    let followers: Followers?
}

struct Followers: Codable {
    let total: Int?
}



struct ImageResponse: Codable {
    let url: String?
    let height: Int?
    let width: Int?
}

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
}

