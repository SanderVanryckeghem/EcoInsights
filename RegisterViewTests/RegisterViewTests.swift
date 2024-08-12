//
//  RegisterViewTests.swift
//  RegisterViewTests
//
//  Created by Jonathan Vercammen on 16/03/2023.
//

import XCTest

final class RegisterViewTests: XCTestCase {
    let app = XCUIApplication()
    
    var emailTextField: XCUIElement!
    var usernameTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var confirmPasswordTextField: XCUIElement!
    var registerButton: XCUIElement!
    var errorMessage: XCUIElement!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        
        let navigateToRegisterButton = app.buttons["registerButton"]
        XCTAssertTrue(navigateToRegisterButton.exists)
        
        navigateToRegisterButton.tap()
        
        emailTextField = app.textFields["registerEmailTextField"]
        usernameTextField = app.textFields["registerUsernameTextField"]
        passwordTextField = app.secureTextFields["registerPasswordTextField"]
        confirmPasswordTextField = app.secureTextFields["registerConfirmPasswordTextField"]
        registerButton = app.buttons["registerButton"]
        errorMessage = app.staticTexts["errorMessage"]
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func enterEmail(email : String) {
        emailTextField.tap()
        emailTextField.typeText(email)
    }
    
    func enterUsername(username : String) {
        usernameTextField.tap()
        usernameTextField.typeText(username)
    }
    
    func enterPassword(password : String) {
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    func enterConfirmationPassword(confirmPassword : String) {
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText(confirmPassword)
    }
    
    func testCheckAllFieldsPresent() throws {
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(usernameTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(confirmPasswordTextField.waitForExistence(timeout: 3))
        XCTAssertTrue(errorMessage.waitForExistence(timeout: 5))
    }
    
    func testRegistrationCorrectPassword() throws {
        enterEmail(email: "john_doe@gmail.com")
        enterUsername(username: "john_doe")
        enterPassword(password: "Azerty123")
        enterConfirmationPassword(confirmPassword: "Azerty123")
        
        registerButton.tap()
        
        XCTAssertEqual(errorMessage.label, "")
    }
    
    func testRegistrationEmptyPassword() throws {
        enterEmail(email: "john_doe@gmail.com")
        enterUsername(username: "john_doe")

        registerButton.tap()

        XCTAssertEqual(errorMessage.label, "Password cannot be empty!")
    }
    
    func testRegistrationDifferentPassword() throws {
        enterEmail(email: "john_doe@gmail.com")
        enterUsername(username: "john_doe")
        enterPassword(password: "Azerty123")
        enterConfirmationPassword(confirmPassword: "321ytrezA")
        
        registerButton.tap()
        
        XCTAssertEqual(errorMessage.label, "Password do not match!")
    }
}
