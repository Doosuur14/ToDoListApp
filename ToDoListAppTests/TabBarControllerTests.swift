//
//  TabBarControllerTests.swift
//  ToDoListAppTests
//
//  Created by Faki Doosuur Doris on 03.09.2025.
//

import XCTest
@testable import ToDoListApp

final class TabBarControllerTests: XCTestCase {

    var tabBarController: TabBarController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let mockToDoListViewModel = ToDoListViewModel()
        tabBarController = TabBarController()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureTabs() throws {
        XCTAssertEqual(tabBarController.viewControllers?.count, 1, "Should have exactly one view controller")

        guard let navController = tabBarController.viewControllers?.first as? UINavigationController else {
            XCTFail("First view controller should be a UINavigationController")
            return
        }
        XCTAssertTrue(navController.topViewController is ToDoListViewController, "Root VC should be ToDoListViewController")

        //let tabItem = navController.tabBarItem
        guard let tabItem: UITabBarItem = navController.tabBarItem else {
            XCTFail("Tab bar item should not be nil")
            return
        }
        XCTAssertEqual(tabItem.title, "", "Tab item title should be empty")
        XCTAssertEqual(tabItem.image?.accessibilityIdentifier, "plus", "Tab item image should be 'plus'")
        XCTAssertEqual(tabItem.tag, 0, "Tab item tag should be 0")


        XCTAssertEqual(tabBarController.tabBar.tintColor, .systemYellow, "Tab bar tint color should be systemYellow")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
