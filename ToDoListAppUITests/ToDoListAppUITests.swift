//
//  ToDoListAppUITests.swift
//  ToDoListAppUITests
//
//  Created by Faki Doosuur Doris on 20.08.2025.
//

import XCTest

final class ToDoListAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAddTask() throws {
        let app = XCUIApplication()
        app.launch()

        let addButton = app.tabBars.buttons["addTab"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()


        let titleField = app.textFields["TaskTitle"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5), "Should navigate to AddTaskViewController with title field visible")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
