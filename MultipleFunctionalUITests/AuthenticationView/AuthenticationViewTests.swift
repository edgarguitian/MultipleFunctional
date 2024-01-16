//
//  AuthenticationViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class AuthenticationViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierTitleAuthenticationView = "textTitleAuthenticationView"
    private let identifierBtnLoginMailAuthenticationView = "btnLoginMailAuthenticationView"
    private let identifierBtnRegisterAuthenticationView = "btnRegisterAuthenticationView"
    private let identifierGroupTitleLoginView = "groupTitleLoginView"
    private let identifierGroupTitleRegisterView = "groupTitleRegisterView"
    private let identifierBtnDismiss = "btnDismiss"

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
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
        XCTAssert(app.staticTexts[identifierTitleAuthenticationView].exists)
        XCTAssert(app.buttons[identifierBtnLoginMailAuthenticationView].exists)
        XCTAssert(app.buttons[identifierBtnRegisterAuthenticationView].exists)
    }

    func test_press_on_login_email() throws {
        let btnLoginMail = app.buttons[identifierBtnLoginMailAuthenticationView]
        XCTAssert(btnLoginMail.exists)
        btnLoginMail.tap()
        print(app.debugDescription)
        XCTAssertTrue(app.staticTexts[identifierGroupTitleLoginView].waitForExistence(timeout: 5))
        let btnDismiss = app.buttons[identifierBtnDismiss]
        XCTAssert(btnDismiss.exists)
        btnDismiss.tap()
        XCTAssertTrue(app.staticTexts[identifierTitleAuthenticationView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[identifierBtnLoginMailAuthenticationView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[identifierBtnRegisterAuthenticationView].waitForExistence(timeout: 5))

    }

    func test_press_on_register() throws {
        let btnRegister = app.buttons[identifierBtnRegisterAuthenticationView]
        XCTAssert(btnRegister.exists)
        btnRegister.tap()
        XCTAssertTrue(app.staticTexts[identifierGroupTitleRegisterView].waitForExistence(timeout: 5))
        let btnDismiss = app.buttons[identifierBtnDismiss]
        XCTAssert(btnDismiss.exists)
        btnDismiss.tap()
        XCTAssertTrue(app.staticTexts[identifierTitleAuthenticationView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[identifierBtnLoginMailAuthenticationView].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons[identifierBtnRegisterAuthenticationView].waitForExistence(timeout: 5))
    }
}
