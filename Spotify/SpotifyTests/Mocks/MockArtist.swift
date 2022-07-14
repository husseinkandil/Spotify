//
//  MockArtist.swift
//  SpotifyTests
//
//  Created by Hussein Kandil on 13/06/2022.
//

import Foundation
@testable import Spotify

struct MockArtist: ArtistProtocol {
    var images: [ImageResponse]? = nil
    
    var name: String = ""
    
    var id: String = ""
    
    var popularity: Int? = 3
    
    var followers: Followers? = nil
    
}
