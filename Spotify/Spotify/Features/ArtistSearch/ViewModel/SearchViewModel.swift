//
//  SearchViewModel.swift
//  Spotify
//
//  Created by Hussein Kandil on 25/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

struct SignedinUserProfile {
    let image: String?
    let username: String
    let id: String
}

extension SignedinUserProfile: Equatable {
    
}

protocol SearchViewModelProtocol: AnyObject {
    var isLoading: BehaviorRelay<Bool> { get }
    var onError: PublishRelay<Error> { get }
    var reload: PublishRelay<Void> { get }
    var artistResponse: BehaviorRelay<ArtistsSearchResponse?> { get }
    var profileImage: BehaviorRelay<UIImage?> { get }
    var searchText: PublishRelay<String> { get }
    var isSignedOut: PublishRelay<Void> { get }
    var emptyText:PublishRelay<String> { get }
      
    var numberOfItems: Int { get }
    var userName: String { get }
    var artistArray: [Artist]? { get set }
        
    func artist(at index: Int) -> Artist
    func getArtists(text: String)
    func signout()
}

final class SearchViewModel: SearchViewModelProtocol {
    
    let isLoading: BehaviorRelay<Bool> = .init(value: false)
    let onError: PublishRelay<Error> = .init()
    let reload: PublishRelay<Void> = .init()
    let artistResponse: BehaviorRelay<ArtistsSearchResponse?> = .init(value: nil)
    let profileImage: BehaviorRelay<UIImage?> = .init(value: nil)
    let searchText: PublishRelay<String> = .init()
    let isSignedOut: PublishRelay<Void> = .init()
    let emptyText:PublishRelay<String> = .init()
    
    var user: SignedinUserProfile
    var artist: ArtistsResponse?
    var artistArray: [Artist]?
    
    var numberOfItems: Int {
        guard let artist = artist else { return 0 }
        return artist.items.count
    }
    
    var userName: String {
        user.username
    }
    
    private var profileImageUrl: String? {
        user.image
    }
    
    var disposedBag = DisposeBag()
    
    init(user: SignedinUserProfile) {
        self.user = user

        searchText
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { strongSelf, text in
                strongSelf.isLoading.accept(true)
                if text == "" {
                    strongSelf.artistArray = []
                    strongSelf.reload.accept(())
                }
                strongSelf.getArtists(text: text)
            }.disposed(by: disposedBag)
        
        if let profileImageUrl = profileImageUrl {
            
            ImageDownlaoder.shared.downloadImage(url: profileImageUrl, completionHandler: { [weak self] image, success in
                guard let self = self else { return }
                
                self.profileImage.accept(image)
            }, placeholderImage: nil)
        }
    }
    
    func artist(at index: Int) -> Artist {
        artist!.items[index]
    }
    
    func getArtists(text: String) {
        APIClient.shared.getartistProfile(artist: text) {[weak self] result in
            guard let self = self else { return }
            self.isLoading.accept(false)
            
            switch result {
            case.success(let model):
                self.artist = model.artists
                self.artistArray = model.artists?.items
                self.artistResponse.accept(model)
                self.reload.accept(())
            case.failure(let error):
                self.onError.accept(error)
            }
        }
    }
    
    func signout() {
            AuthenticationManager.shared.signout { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    AuthenticationManager.shared.clearUser()
                    self.isSignedOut.accept(())
            }
        }
    }
}
