import XCTest

@MainActor
final class NavigationSmokeTests: XCTestCase {
    func testNavigateFoundationAndCaptureScreenshots() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["home.headline"].waitForExistence(timeout: 10))
        capture("01-home", app: app)

        app.tabBars.buttons["Library"].tap()
        XCTAssertTrue(app.staticTexts["A place for useful context"].waitForExistence(timeout: 5))
        capture("05-library", app: app)

        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.staticTexts["Find the things that matter"].waitForExistence(timeout: 5))
        capture("06-semantic-search-empty", app: app)

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["On-device only"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["settings.privacyExplanation"].exists)
        capture("07-settings-privacy", app: app)
    }

    func testDarkLargeTextPrivacyScreen() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-dark", "-ui-large-text"]
        app.launch()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.staticTexts["On-device only"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["settings.privacyExplanation"].isHittable)
        capture("08-privacy-dark-large-text", app: app)
    }

    private func capture(_ name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
