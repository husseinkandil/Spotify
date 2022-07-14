//
//  SpotifyUITests.swift
//  SpotifyUITests
//
//  Created by Hussein Kandil on 06/06/2022.
//

import XCTest
import UIKit

class SpotifyUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testLoginButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let button = app.buttons["Log in"]
        XCTAssertTrue(button.exists)
        button.tap()
    }
    
    func testSearch() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        XCUIApplication().searchFields["Search for an artist..."].tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.otherElements.containing(.staticText, identifier:"The Weeknd").element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements.containing(.staticText, identifier:"Dawn FM").element.swipeUp()
        app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".images[\"Circle\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testLogout() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars["Artists"].children(matching: .image).element.tap()
        app.sheets["Hussein Kandil"].scrollViews.otherElements.buttons["Log out"].tap()
        app.alerts["Log out"].scrollViews.otherElements.buttons["Yes"].tap()
        
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
