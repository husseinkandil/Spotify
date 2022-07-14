//
//  ArtistalbumResponse.swift
//  Spotify
//
//  Created by Hussein Kandil on 20/05/2022.
//

import Foundation

struct Album: Codable {
    let items: [AlbumResponse]
}

struct AlbumResponse: Codable {
    let artists: [AlbumArtistDetail]
    let images: [ImageResponse]?
    let external_urls: [String: String]
    let name: String?
    let total_tracks: Int?
    let release_date: String?
}

struct AlbumArtistDetail: Codable {
    let name: String?
}

