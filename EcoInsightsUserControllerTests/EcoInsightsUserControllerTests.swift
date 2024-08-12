//
//  EcoInsightsUserControllerTests.swift
//  EcoInsightsUserControllerTests
//
//  Created by Jonathan Vercammen on 27/04/2023.
//

import XCTest

final class EcoInsightsUserControllerTests: XCTestCase {
    
    var sut: UserController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UserController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testRegisterSuccess() {
        let expectation = self.expectation(description: "register")
        let email = "test2@test.com"
        let password = "password"
        sut.register(email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertEqual(user.email, email)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Registration failed with error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginSuccess() {
        let expectation = self.expectation(description: "login")
        let email = "test@test.com"
        let password = "password"
        sut.login(email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
                XCTAssertEqual(user.email, email)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Login failed with error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginFailure() {
        let expectation = self.expectation(description: "login")
        let email = "test@test.com"
        let password = "wrongpassword"
        sut.login(email: email, password: password) { (result) in
            switch result {
            case .success:
                XCTFail("Login should have failed")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    
    func testRegisterFailure() {
        let expectation = self.expectation(description: "register")
        let email = "test@test.com" // existing email
        let password = "password"
        sut.register(email: email, password: password) { (result) in
            switch result {
            case .success:
                XCTFail("Registration should have failed")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
