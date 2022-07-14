//
//  SpotifyTests.swift
//  SpotifyTests
//
//  Created by Zein Abdalla on 23/05/2022.
//

import XCTest


@testable import Spotify

class SpotifyTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberFomatter() {
        let numberOfFollowers = 1234567
        let result = SpotifyNumberFormatter.formattedNumberOfFollowers(numberOfFollowers: numberOfFollowers)
        let expectedResult = "1,234,567"
        XCTAssertEqual(result, expectedResult)
    }
    
    func testNumberOfstars() {
        let result = 3
        let model = ArtistCollectionViewCell()
        let mock = MockArtist()
        model.populate(model: mock)
        
        XCTAssertEqual(mock.popularity, result)
    }

}
