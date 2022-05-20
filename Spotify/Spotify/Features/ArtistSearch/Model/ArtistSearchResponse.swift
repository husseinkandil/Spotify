//
//  ArtistSearchResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 19/05/2022.
//

import Foundation

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
