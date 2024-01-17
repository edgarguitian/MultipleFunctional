//
//  HomeViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class HomeViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierBtnLoginMailAuthenticationView = "btnLoginMailAuthenticationView"
    private let identifierGroupTitleLoginView = "groupTitleLoginView"
    private let identifierDescriptionLoginView = "textDescriptionLoginView"
    private let identifierFieldEmailLoginView = "fieldEmailLoginView"
    private let identifierFieldPassLoginView = "fieldPassLoginView"
    private let identifierBtnLoginMailLoginView = "btnLoginEmailLoginView"
    private let identifierTitleHomeView = "titleHomeView"
    private let identifierBtnShopHomeView = "btnShopHomeView"
    private let identifierBtnActiveSubscriptionHomeView = "btnSubscriptionActiveHomeView"

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        // Logout if is possible
        let btnLogout = app.buttons[identifierBtnLogout]
        if !btnLogout.exists {
            launch_login_view()
        }

    }

    override func tearDown() {
        app = nil
    }

    func launch_login_view() {
        let btnLoginMail = app.buttons[identifierBtnLoginMailAuthenticationView]
        XCTAssert(btnLoginMail.exists)
        btnLoginMail.tap()
        print(app.debugDescription)
        XCTAssertTrue(app.staticTexts[identifierGroupTitleLoginView].waitForExistence(timeout: 5))
        complete_login_view()
    }

    func complete_login_view() {
        let fieldEmail = app.textFields[identifierFieldEmailLoginView]
        XCTAssert(fieldEmail.exists)
        fieldEmail.tap()
        fieldEmail.typeText("test@gmail.com")
        let fieldPassword = app.textFields[identifierFieldPassLoginView]
        XCTAssert(fieldPassword.exists)
        fieldPassword.tap()
        fieldPassword.typeText("test123")
        let btnLogin = app.buttons[identifierBtnLoginMailLoginView]
        XCTAssert(btnLogin.exists)
        btnLogin.tap()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertTrue(titleHomeView.waitForExistence(timeout: 5))
    }

    func test_home_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierTitleHomeView].exists)
        XCTAssert(app.buttons[identifierBtnShopHomeView].exists)
        XCTAssert(app.buttons[identifierBtnLogout].exists)

    }
}
