////
////  WelcomeViewTests.swift
////  WelcomeViewTests
////
////  Created by Jonathan Vercammen on 09/03/2023.
////
//
//import XCTest
//
//final class WelcomeViewTests: XCTestCase {
//    let app = XCUIApplication()
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        app.launch()
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//
//    func testLogoExists() throws {
//        let logo = app.images["logo"]
//        XCTAssertTrue(logo.exists)
//    }
//
//    func testTitleExists() throws {
//        let title = app.staticTexts["title"]
//        XCTAssertTrue(title.exists)
//    }
//
//    func testSubtitleExists() throws {
//        let subtitle = app.staticTexts["subtitle"]
//        XCTAssertTrue(subtitle.exists)
//    }
//
//    func testExploreButton() throws {
//        let exploreButton = app.buttons["exploreNowButton"]
//        XCTAssertTrue(exploreButton.exists)
//
////        exploreButton.tap()
//
////        let newPageTitle = app.staticTexts["AR Scanner"]
////        XCTAssertTrue(newPageTitle.exists)
//    }
//
//    func testLoginButton() throws {
//        let loginButton = app.buttons["loginButton"]
//        XCTAssertTrue(loginButton.exists)
//
////        loginButton.tap()
//
////        let newPageTitle = app.staticTexts["Login"]
////        XCTAssertTrue(newPageTitle.exists)
//    }
//
//    func testRegisterButtonNavigation() {
//        let registerButton = app.buttons["registerButton"]
//        XCTAssertTrue(registerButton.exists)
//
//        registerButton.tap()
//
//        let registerEmailTextField = app.textFields["registerEmailTextField"]
//        XCTAssertTrue(registerEmailTextField.waitForExistence(timeout: 5))
//    }
//
//}
