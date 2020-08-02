//
//  SampleCoreDataSwiftUIMVVMUITests.swift
//  SampleCoreDataSwiftUIMVVMUITests
//
//  Created by Chris Jones on 02/08/2020.
//

import XCTest

class SampleCoreDataSwiftUIMVVMUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments += ["UI-TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewPerson() throws {
        let preCount = app.tables.cells.count
        XCUIApplication().tables.buttons["Add person..."].tap()
        let postCount = app.tables.cells.count

        XCTAssert(postCount - preCount == 1)
    }

    func testRestoreDefaults() throws {
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Reset to defaults"]/*[[".cells[\"Reset to defaults\"].buttons[\"Reset to defaults\"]",".buttons[\"Reset to defaults\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.sheets["Are you sure?"].scrollViews.otherElements.buttons["Reset Peoplr"].tap()

        XCTAssert(app.tables.cells.count == 5)
    }

    func testDeletePerson() throws {
        let preCount = app.tables.cells.count

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Billy Windowson\n(Summer Vacation)\nEvery day"]/*[[".cells[\"Billy Windowson\\n(Summer Vacation)\\nEvery day\"].buttons[\"Billy Windowson\\n(Summer Vacation)\\nEvery day\"]",".buttons[\"Billy Windowson\\n(Summer Vacation)\\nEvery day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete Person"]/*[[".cells[\"Delete Person\"].buttons[\"Delete Person\"]",".buttons[\"Delete Person\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.sheets["Are you sure?"].scrollViews.otherElements.buttons["Delete"].tap()

        let postCount = app.tables.cells.count

        print("pre: \(preCount), post: \(postCount)")
        XCTAssert(postCount - preCount == 1)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
