//
//  ProductsViewTests.swift
//  ProductsViewTests
//
//  Created by Robbe Van hoorebeke on 31/03/2023.
//

import XCTest

final class ProductsViewTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testProductsView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Find the "Products" title and verify it's visible
        let titleLabel = app.staticTexts["title"]
        XCTAssertTrue(titleLabel.exists)
        XCTAssertTrue(titleLabel.isHittable)
        
        // Scroll down to the bottom of the product list
        let lastProduct = app.staticTexts["Product 16"]
        XCTAssertTrue(lastProduct.exists)
        XCTAssertTrue(lastProduct.isHittable)
        lastProduct.swipeUp()
        sleep(1)
        
        // Tap the last product to show its detail view
        lastProduct.tap()
        sleep(1)
        
        // Find the "Like" button and tap it to toggle its state
        let likeButton = app.buttons["Like"]
        XCTAssertTrue(likeButton.exists)
        XCTAssertTrue(likeButton.isHittable)
        let initialState = likeButton.isSelected
        likeButton.tap()
        sleep(1)
        XCTAssertNotEqual(initialState, likeButton.isSelected)
    }
    
}
