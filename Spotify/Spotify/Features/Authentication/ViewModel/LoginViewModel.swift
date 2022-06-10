//
//  LoginViewModel.swift
//  Spotify
//
//  Created by Hussein Kandil on 01/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelProtocol: AnyObject {
    var onError: PublishRelay<Error> { get }
    var signedInUserProfile: PublishRelay<SignedinUserProfile?> { get }
    var code: PublishRelay<String> { get }
    
    var isSignedIn: Bool { get }
    var signinUrl: URL { get }
    var user: UserProfile? { get }
}

class LoginViewModel: LoginViewModelProtocol {
    let onError: PublishRelay<Error> = .init()
    let signedInUserProfile: PublishRelay<SignedinUserProfile?> = .init()
    let code: PublishRelay<String> = .init()
    
    private let disposedBag = DisposeBag()
    
    var signinUrl: URL {
        guard let url = AuthenticationManager.shared.signinURL else {
            return URL(string: "")!
        }
        return url
    }
    
    var user: UserProfile? {
        didSet {
            guard let user = user else {
                return
            }
            AuthenticationManager.shared.saveUser(user: user)
        }
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    var username: String {
        guard let user = user else { return ""}
        return user.display_name
    }

    var image: String {
        guard let user = user, let imageUrl = user.images.first?.url else { return "" }
        return imageUrl
    }

    var id: String {
        guard let user = user else { return "" }
        return user.id
    }
    
    private let apiClient: UserProfileAPIClient
    private let authenticationManager: AuthenticationManagerProtocol
    
    init(with apiClient: UserProfileAPIClient, authManager: AuthenticationManagerProtocol = AuthenticationManager.shared) {
        self.authenticationManager = authManager
        self.apiClient = apiClient
        
        code
            .withUnretained(self)
            .bind { strongSelf, code in
                strongSelf.fetchToken(code: code)
            }.disposed(by: disposedBag)
    }
    
    private func fetchToken(code: String) {
        authenticationManager.generateToken(code: code) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.login()
            } else {
                self.onError.accept(APIError.custom(message: "Failed to fetch token!"))
            }
        }
    }
    
    private func login() {
        apiClient.getUserProfile { [weak self] result in
            guard let self = self else{ return}
            
            switch result {
            case.success(let user):
                self.user = user
                self.setupUser()
            case.failure(let error):
                self.onError.accept(error)
            }
        }
    }
    
    private func setupUser() {
        
        if let username = user?.display_name, let id = user?.id {
            let imageUrl = user?.images.first?.url
            let userData = SignedinUserProfile(image: imageUrl, username: username, id: id)
            self.signedInUserProfile.accept(userData)
        } else {
            self.onError.accept(APIError.custom(message: "failed to fetch data!"))
        }
    }
}
