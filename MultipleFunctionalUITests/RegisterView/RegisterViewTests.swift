//
//  RegisterViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class RegisterViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierBtnRegisterAuthenticationView = "btnRegisterAuthenticationView"
    private let identifierGroupTitleRegisterView = "groupTitleRegisterView"
    private let identifierDescriptionRegisterView = "textDescriptionRegisterView"
    private let identifierFieldEmailRegisterView = "fieldEmailRegisterView"
    private let identifierFieldPassRegisterView = "fieldPassRegisterView"
    private let identifierBtnRegisterMailRegisterView = "btnRegisterEmailRegisterView"
    private let identifierTextErrorMessageLoginView = "registerViewErrorMessage"
    private let identifierTitleHomeView = "titleHomeView"

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        // Logout if is possible
        let btnLogout = app.buttons[identifierBtnLogout]
        if btnLogout.exists {
            btnLogout.tap()
        }
        launch_register_view()
    }

    override func tearDown() {
        app = nil
    }

    func launch_register_view() {
        let btnRegisterMail = app.buttons[identifierBtnRegisterAuthenticationView]
        XCTAssert(btnRegisterMail.exists)
        btnRegisterMail.tap()
        print(app.debugDescription)
        XCTAssertTrue(app.staticTexts[identifierGroupTitleRegisterView].waitForExistence(timeout: 5))
    }

    func test_register_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierDescriptionRegisterView].exists)
        XCTAssert(app.textFields[identifierFieldEmailRegisterView].exists)
        XCTAssert(app.secureTextFields[identifierFieldPassRegisterView].exists)
        XCTAssert(app.buttons[identifierBtnRegisterMailRegisterView].exists)

    }

    func test_complete_register_error() throws {
        let fieldEmail = app.textFields[identifierFieldEmailRegisterView]
        XCTAssert(fieldEmail.exists)
        fieldEmail.tap()
        fieldEmail.typeText("testEmail")
        let fieldPassword = app.secureTextFields[identifierFieldPassRegisterView]
        XCTAssert(fieldPassword.exists)
        fieldPassword.tap()
        fieldPassword.typeText("testPassword")
        let btnRegister = app.buttons[identifierBtnRegisterMailRegisterView]
        XCTAssert(btnRegister.exists)
        btnRegister.tap()
        let textErrorMessage = app.staticTexts[identifierTextErrorMessageLoginView]
        XCTAssertTrue(textErrorMessage.waitForExistence(timeout: 5))

    }
    
    func test_complete_register_success() throws {
        let fieldEmail = app.textFields[identifierFieldEmailRegisterView]
        XCTAssert(fieldEmail.exists)
        fieldEmail.tap()
        fieldEmail.typeText("testEmail@gmail.com")
        let fieldPassword = app.secureTextFields[identifierFieldPassRegisterView]
        XCTAssert(fieldPassword.exists)
        fieldPassword.tap()
        fieldPassword.typeText("pass123")
        let btnRegister = app.buttons[identifierBtnRegisterMailRegisterView]
        XCTAssert(btnRegister.exists)
        btnRegister.tap()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertTrue(titleHomeView.waitForExistence(timeout: 5))

    }
}
