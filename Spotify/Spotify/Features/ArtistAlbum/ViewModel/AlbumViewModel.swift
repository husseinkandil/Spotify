//
//  AlbumViewModel.swift
//  Spotify
//
//  Created by Hussein Kandil on 25/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol AlbumViewModelProtocol: AnyObject {
    var isLoading: BehaviorRelay<Bool> { get }
    var onError: PublishRelay<Error> { get }
    var reload: PublishRelay<Void> { get }
    var openUrl: PublishRelay<URL> { get }
    var headerModel: BehaviorRelay<AlbumHeaderModel?> { get }
    
    var numberOfItems: Int { get }
    var artistName: String { get }
    
    func didSelectAlbum(at index: Int)
    func album(at index: Int) -> AlbumResponse
}

struct AlbumHeaderModel {
    let followersLabelText: String
    let artistName: String
    let artistImageUrl: String?
}

final class AlbumViewModel: AlbumViewModelProtocol {
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let onError: PublishRelay<Error> = .init()
    let reload: PublishRelay<Void> = .init()
    let openUrl: PublishRelay<URL> = .init()
    let headerModel: BehaviorRelay<AlbumHeaderModel?> = .init(value: nil)
    
    var artist: Artist
    var album: Album?
    
    var artistId: String {
        artist.id
    }
    
    var artistName: String {
        artist.name
    }
    
    var numberOfItems: Int {
        guard let album = album else { return 0 }
        return album.items.count
    }
    
    init(artist: Artist) {
        self.artist = artist
        getArtistAlbum()
        generateHeaderModel()
    }
    
    func getArtistAlbum() {
        APIClient.shared.getArtistAlbum(id: artistId) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            
            switch result {
            case.success(let album):
                self.album = album
                self.reload.accept(())
            case.failure(let error):
                self.onError.accept(error)
            }
        }
    }
    
    func didSelectAlbum(at index: Int) {
        if let urlString = album?.items[index].external_urls["spotify"],
           let url = URL(string: urlString) {
            openUrl.accept(url)
        }
    }
    
    func album(at index: Int) -> AlbumResponse {
        album!.items[index]
    }
    
    private func generateHeaderModel() {
        var numberOfFollowersText = "-- followers"
        if let numberOfFollowers = artist.followers?.total {
            let formatted = SpotifyNumberFormatter.formattedNumberOfFollowers(numberOfFollowers: numberOfFollowers)
            numberOfFollowersText = "\(formatted) followers"
        }
        let artistName = artist.name
        let artistImageUrl = artist.images?.first?.url
        
        let headerModel = AlbumHeaderModel(followersLabelText: numberOfFollowersText,
                                           artistName: artistName,
                                           artistImageUrl: artistImageUrl)
        
        self.headerModel.accept(headerModel)
        
    }
    
}
