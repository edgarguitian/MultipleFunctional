//
//  AuthenticationViewInitialLoadingTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class AuthenticationViewInitialLoadingTests: XCTestCase {
    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierTitleAuthenticationView = "textTitleAuthenticationView"
    private let identifierLoadingIndicator = "LoadingIndicator"

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments += ["UITestInitialLoading"]

        app.launch()
        // Logout if is possible
        let btnLogout = app.buttons[identifierBtnLogout]
        if btnLogout.exists {
            btnLogout.tap()
        }
    }

    override func tearDown() {
        app = nil
    }

    func test_initial_loading() throws {
        print(app.debugDescription)
        XCTAssert(app.activityIndicators[identifierLoadingIndicator].exists)

        sleep(3)
        print(app.debugDescription)

        XCTAssertFalse(app.activityIndicators[identifierLoadingIndicator].exists)
        XCTAssertTrue(app.staticTexts[identifierTitleAuthenticationView].waitForExistence(timeout: 5))

    }
}
