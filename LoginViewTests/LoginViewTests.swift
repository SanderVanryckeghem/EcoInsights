//
//  LoginViewTests.swift
//  LoginViewTests
//
//  Created by Robbe Van hoorebeke on 24/03/2023.
//

import XCTest

final class LoginViewTests: XCTestCase {
    let app = XCUIApplication()
    
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var errorMessage: XCUIElement!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        emailTextField = app.textFields["loginEmailTextField"]
        passwordTextField = app.secureTextFields["loginPasswordTextField"]
        loginButton = app.buttons["loginButton"]
        errorMessage = app.staticTexts["errorMessage"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func typeEmail(email : String) {
        emailTextField.tap()
        emailTextField.typeText(email)
    }
    
    func typePassword(password : String) {
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    func testAllFieldsPresent() {
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 3))
    }
    
    func testLoginEmptyEmail() {
        typePassword(password: "Azerty123")
        
        loginButton.tap()
        
        XCTAssertEqual(errorMessage.label, "Please enter your email")
    }
    
    func testPasswordEmpty() {
        typeEmail(email: "john_doe@gmail.com")
        
        loginButton.tap()
        
        XCTAssertEqual(errorMessage.label, "Password cannot be empty!")
    }
    
    //TODO: test login functionality
}
