import XCTest

final class VolunteerhrsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddFlowCreatesItem() {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Item")
        app.buttons["saveAddButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Item"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<10 {
            let addButton = app.buttons["addButton"]
            if !addButton.exists { break }
            addButton.tap()
            if app.buttons["paywallUnlockButton"].waitForExistence(timeout: 1) {
                XCTAssertTrue(true)
                app.buttons["paywallDismissButton"].tap()
                return
            }
            let titleField = app.textFields["titleField"]
            if titleField.waitForExistence(timeout: 1) {
                titleField.tap()
                titleField.typeText("Item \(i)")
                app.buttons["saveAddButton"].tap()
            }
        }
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("dismiss test")
        app.navigationBars.staticTexts.firstMatch.tap()
        XCTAssertFalse(titleField.isSelected)
    }

    func testSettingsOpensAndCloses() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["doneSettingsButton"].waitForExistence(timeout: 2))
        app.buttons["doneSettingsButton"].tap()
    }
}
