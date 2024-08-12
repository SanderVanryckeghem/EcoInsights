//
//  RegisterViewTestsLaunchTests.swift
//  RegisterViewTests
//
//  Created by Jonathan Vercammen on 16/03/2023.
//

import XCTest

final class RegisterViewTestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
        let registerButton = app.buttons["registerButton"]
        XCTAssertTrue(registerButton.exists)
        
        registerButton.tap()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
