//
//  ProductsViewSearchTests.swift
//  EcoInsights
//
//  Created by Jonathan Vercammen on 31/03/2023.
//

import XCTest

final class ProductsViewSearchTests: XCTestCase {
    let app = XCUIApplication()
    
    var searchButton: XCUIElement!
    var searchBar: XCUIElement!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        searchButton = app.buttons["searchButton"]
        searchBar = app.textFields["searchBar"]
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchExists() throws {
        XCTAssertTrue(searchButton.waitForExistence(timeout: 3))
        XCTAssertTrue(searchBar.waitForExistence(timeout: 3))
    }
    
}
