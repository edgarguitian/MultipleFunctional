//
//  AuthenticationViewErrorTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class AuthenticationViewErrorTests: XCTestCase {

    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierErrorMessageAuthenticationView = "authenticationViewErrorMessage"

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments += ["UITestErrorHandling"]

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

    func test_authentication_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierErrorMessageAuthenticationView].exists)

    }
}
