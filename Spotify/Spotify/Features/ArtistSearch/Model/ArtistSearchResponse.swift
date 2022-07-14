//
//  ArtistSearchResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 19/05/2022.
//

import Foundation

protocol ArtistProtocol {
    var images: [ImageResponse]? { get }
    var name: String { get }
    var id: String { get }
    var popularity: Int? { get }
    var followers: Followers? { get }
}

struct ArtistsSearchResponse: Codable {
    let artists: ArtistsResponse?
}

struct ArtistsResponse: Codable {
    let href: String?
    var items: [Artist]
}

struct Artist: ArtistProtocol ,Codable {
    var images: [ImageResponse]?
    let name: String
    let id: String
    let popularity: Int?
    let followers: Followers?
}

struct Followers: Codable {
    let total: Int?
}
