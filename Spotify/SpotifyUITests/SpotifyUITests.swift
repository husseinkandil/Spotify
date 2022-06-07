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
                
                let webViewsQuery = app.webViews.webViews.webViews
                
                let usernameTextField = webViewsQuery/*@START_MENU_TOKEN@*/.textFields["Email address or username"]/*[[".otherElements[\"Login - Spotify\"].textFields[\"Email address or username\"]",".textFields[\"Email address or username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                usernameTextField.tap()
                usernameTextField.typeText("husseinkandil19@gmail.com")


                let passTextField = webViewsQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".otherElements[\"Login - Spotify\"].secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                passTextField.tap()
                passTextField.typeText("Test@123456")

                let loginbutton = webViewsQuery/*@START_MENU_TOKEN@*/.buttons["LOG IN"]/*[[".otherElements[\"Login - Spotify\"].buttons[\"LOG IN\"]",".buttons[\"LOG IN\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                XCTAssertTrue(loginbutton.exists)
                loginbutton.tap()
                
                let agreeButton = app.webViews.webViews.webViews/*@START_MENU_TOKEN@*/.buttons["AGREE"]/*[[".otherElements[\"Authorize - Spotify\"].buttons[\"AGREE\"]",".buttons[\"AGREE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                agreeButton.tap()
                                                    
    }
    
    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()
        let artistSearch = app.searchFields["Search for an artist..."]
        artistSearch.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let taylorSwiftElement = app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Taylor Swift").element
        taylorSwiftElement.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".images[\"Circle\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        taylorSwiftElement.tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).otherElements.containing(.staticText, identifier:"Red (Taylor's Version)").element.tap()
        app.buttons["Done"].tap()

        let verticalScrollBar5PagesCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 5 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 5 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        verticalScrollBar5PagesCollectionView.swipeUp()
        verticalScrollBar5PagesCollectionView.tap()
        app.navigationBars["Taylor Swift"].buttons["Back"].tap()
                        
    }
    
    func testLogout() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        let image = app.navigationBars["Artists"].children(matching: .image).element
        XCTAssertTrue(image.exists)
        image.tap()
        
        let sheet = app.sheets["Profile"].scrollViews.otherElements
        
        let logoutButton = sheet.buttons["Log out"]
        XCTAssertTrue(logoutButton.exists)
        logoutButton.tap()
        
        let alert = app.alerts["Log out"].scrollViews.otherElements
            let yesButton = alert.buttons["Yes"]
        yesButton.tap()
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
