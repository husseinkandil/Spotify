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
    var completion: BehaviorRelay<Bool> { get }
    
    func login()
}

class LoginViewModel: LoginViewModelProtocol {
    let onError: PublishRelay<Error> = .init()
    let signedInUserProfile: PublishRelay<SignedinUserProfile?> = .init()
    let code: PublishRelay<String> = .init()
    let completion: BehaviorRelay<Bool> = .init(value: false)
    
    private let disposedBag = DisposeBag()
    
    var user: UserProfile?
    
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
    
    init() {
        code
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { strongSelf, code in
                strongSelf.fetchToken(code: code)
            }.disposed(by: disposedBag)
    }
    
    func fetchToken(code: String) {
        AuthenticationManager.shared.generateToken(code: code) { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.completion.accept(true)
                self.login()
            }
        }
    }
    
    func login() {
        APIClient.shared.getUserProfile { [weak self] result in
            guard let self = self else{ return}
            
            switch result {
            case.success(let user):
                self.completion.accept(true)
                self.user = user
                self.setupUser()
            case.failure(let error):
                self.onError.accept(error)
            }
        }
    }
    
    func setupUser() {
        
        if let username = user?.display_name, let imageUrl = user?.images.first?.url, let id = user?.id {
            let userData = SignedinUserProfile(image: imageUrl, username: username, id: id)
            self.signedInUserProfile.accept(userData)
            
        }
    }
}
