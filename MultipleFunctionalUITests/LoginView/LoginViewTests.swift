//
//  LoginViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class LoginViewTests: XCTestCase {

    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierBtnLoginMailAuthenticationView = "btnLoginMailAuthenticationView"
    private let identifierGroupTitleLoginView = "groupTitleLoginView"
    private let identifierDescriptionLoginView = "textDescriptionLoginView"
    private let identifierFieldEmailLoginView = "fieldEmailLoginView"
    private let identifierFieldPassLoginView = "fieldPassLoginView"
    private let identifierSecureFieldPassLogin = "secureFieldPassLoginView"
    private let identifierBtnLoginMailLoginView = "btnLoginEmailLoginView"
    private let identifierBtnShowPassLogin = "btnShowPassLogin"
    private let identifierTextErrorMessageLoginView = "loginViewErrorMessage"
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
        launch_login_view()
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
    }

    func test_login_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierDescriptionLoginView].exists)
        XCTAssert(app.textFields[identifierFieldEmailLoginView].exists)
        XCTAssert(app.textFields[identifierFieldPassLoginView].exists)
        XCTAssert(app.secureTextFields[identifierSecureFieldPassLogin].exists)
        XCTAssert(app.buttons[identifierBtnShowPassLogin].exists)
        XCTAssert(app.buttons[identifierBtnLoginMailLoginView].exists)

    }

    func test_complete_login_error() throws {
        let fieldEmail = app.textFields[identifierFieldEmailLoginView]
        XCTAssert(fieldEmail.exists)
        fieldEmail.tap()
        fieldEmail.typeText("testEmail")
        let fieldPassword = app.secureTextFields[identifierSecureFieldPassLogin]
        XCTAssert(fieldPassword.exists)
        fieldPassword.tap()
        fieldPassword.typeText("testPassword")
        let btnLogin = app.buttons[identifierBtnLoginMailLoginView]
        XCTAssert(btnLogin.exists)
        btnLogin.tap()
        let textErrorMessage = app.staticTexts[identifierTextErrorMessageLoginView]
        XCTAssertTrue(textErrorMessage.waitForExistence(timeout: 5))

    }

    func test_complete_login_success() throws {
        let fieldEmail = app.textFields[identifierFieldEmailLoginView]
        XCTAssert(fieldEmail.exists)
        fieldEmail.tap()
        fieldEmail.typeText("test@gmail.com")
        let fieldPassword = app.secureTextFields[identifierSecureFieldPassLogin]
        XCTAssert(fieldPassword.exists)
        fieldPassword.tap()
        fieldPassword.typeText("test123")
        let btnLogin = app.buttons[identifierBtnLoginMailLoginView]
        XCTAssert(btnLogin.exists)
        btnLogin.tap()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertTrue(titleHomeView.waitForExistence(timeout: 5))

    }

    func test_show_password() throws {
        let mockPass = "test123"
        let secureFieldPass = app.secureTextFields[identifierSecureFieldPassLogin]
        XCTAssert(secureFieldPass.exists)
        secureFieldPass.tap()
        secureFieldPass.typeText(mockPass)
        guard let textoAntes = secureFieldPass.value as? String else {
            XCTFail("Texto de la password oculta incorrecta")
            return
        }

        let btnShowPass = app.buttons[identifierBtnShowPassLogin]
        XCTAssert(btnShowPass.exists)
        btnShowPass.tap()
        let fieldPass = app.textFields[identifierFieldPassLoginView]
        guard let textoDespues = fieldPass.value as? String else {
            XCTFail("Texto de la password mostrada incorrecta")
            return
        }
        XCTAssertNotEqual(textoAntes, textoDespues)

    }

}
