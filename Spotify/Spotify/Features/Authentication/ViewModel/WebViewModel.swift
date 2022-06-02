//
//  WebViewModel.swift
//  Spotify
//
//  Created by Hussein Kandil on 01/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

//protocol WebViewModelProtocol: AnyObject {
//    var code: PublishRelay<String> { get }
//    var completion: BehaviorRelay<Bool> { get }
//}
//
//class WebViewModel: WebViewModelProtocol {
//    let code: PublishRelay<String> = .init()
//    let completion: BehaviorRelay<Bool> = .init(value: false)
//    
//    private let disposeBag = DisposeBag()
//    
//    init() {   
//        code
//            .withUnretained(self)
//            .observe(on: MainScheduler.instance)
//            .bind { strongSelf, code in
//                strongSelf.fetchToken(code: code)
//            }.disposed(by: disposeBag)
//    }
//    
//    func fetchToken(code: String) {
//        AuthenticationManager.shared.generateToken(code: code) { [weak self] success in
//            print(success)
//            guard let self = self else { return }
//            if success {
//                self.completion.accept(true)
//            }
//        }
//    }
//}
