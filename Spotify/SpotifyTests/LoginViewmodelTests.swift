//
//  LoginViewmodelTests.swift
//  SpotifyTests
//
//  Created by Hussein Kandil on 10/06/2022.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import Spotify

class LoginViewmodelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    var sut: LoginViewModelProtocol!
    var apiClient: MockUserProfile!
    var authManager: MockAuthManager!

    override func setUpWithError() throws {
        apiClient = MockUserProfile()
        authManager = MockAuthManager()
        sut = LoginViewModel(with: apiClient, authManager: authManager)
        
        scheduler = .init(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        apiClient = nil
        authManager = nil
        disposeBag = nil
        scheduler = nil
    }
    
    func testCode() {
        let code = scheduler.createObserver(String.self)
        sut.code.bind(to: code).disposed(by: disposeBag)
        scheduler.start()
        
        sut.code.accept("123")
        sut.code.accept("456")
        XCTAssertEqual(code.events, [.next(0, "123"), .next(0, "456")])
        
    }
    
    func testFetchToken() {
        sut.code.accept("hello")
        XCTAssertEqual("hello", authManager.codetest)
    }

    func testGetUserProfile_shouldFail() {
        let onError = scheduler.createObserver(Error.self)
        sut.onError.bind(to: onError).disposed(by: disposeBag)
        scheduler.start()
        
        apiClient.shouldFail = true
        sut.code.accept("hello")
        
        XCTAssertEqual(onError.events.count, 1)
    }
    
    func testGetUser_shouldNotFail() {
        let onError = scheduler.createObserver(Error.self)
        sut.onError.bind(to: onError).disposed(by: disposeBag)
        scheduler.start()
        
        apiClient.shouldFail = false
        sut.code.accept("hello")
        
        XCTAssertEqual(onError.events.count, 0)
        
        XCTAssertEqual(sut.user?.display_name, "kandil")
    }
    
    func testSetupUesr() {
        let signInUserProfile = scheduler.createObserver(SignedinUserProfile?.self)
        sut.signedInUserProfile.bind(to: signInUserProfile).disposed(by: disposeBag)
        scheduler.start()
        
        sut.code.accept("hello")
        
        let userProfile = SignedinUserProfile.init(image: nil, username: "kandil", id: "123")
        
        XCTAssertEqual(signInUserProfile.events, [.next(0, userProfile)])
    }
}


