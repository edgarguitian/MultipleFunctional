//
//  AuthenticationViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest

final class AuthenticationViewTests: XCTestCase {

    private var app: XCUIApplication!
    let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    private let identifierBtnLogout = "btnLogout"
    private let identifierTitleAuthenticationView = "textTitleAuthenticationView"
    private let identifierBtnLoginMailAuthenticationView = "btnLoginMailAuthenticationView"
    private let identifierBtnLoginAppleAuthView = "btnLoginAppleAuthenticationView"
    private let identifierBtnFaceIdAuthenticationView = "btnFaceIdAuthenticationView"
    private let identifierBtnRegisterAuthenticationView = "btnRegisterAuthenticationView"
    private let identifierGroupTitleLoginView = "groupTitleLoginView"
    private let identifierGroupTitleRegisterView = "groupTitleRegisterView"
    private let identifierBtnDismiss = "btnDismiss"
    private let identifierErrorAuthentication = "authenticationViewErrorMessage"
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
    }

    override func tearDown() {
        app = nil
    }

    func test_authentication_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierTitleAuthenticationView].exists)
        XCTAssert(app.buttons[identifierBtnLoginMailAuthenticationView].exists)
        XCTAssert(app.buttons[identifierBtnLoginAppleAuthView].exists)
        XCTAssert(app.buttons[identifierBtnFaceIdAuthenticationView].exists)
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

    func test_press_on_login_apple_success() throws {
        let btnLoginApple = app.buttons[identifierBtnLoginAppleAuthView]
        XCTAssert(btnLoginApple.exists)
        btnLoginApple.tap()
        let btnContinue = springBoard.buttons["Continue with Password"]

        XCTAssert(btnContinue.waitForExistence(timeout: 5), springBoard.debugDescription)
        let btnShareMyEmail = springBoard.cells["SIWA_SHARE_MY_EMAIL_SCOPE_CELL"]
        if btnShareMyEmail.exists {
            btnShareMyEmail.tap()
        }
        btnContinue.tap()
        let secureTextField = springBoard.secureTextFields.firstMatch
        XCTAssert(secureTextField.waitForExistence(timeout: 5), springBoard.debugDescription)
        secureTextField.typeText("SET PASSWORD HERE")
        let btnSignIn = springBoard.buttons["Sign In"]
        XCTAssert(btnSignIn.waitForExistence(timeout: 5), springBoard.debugDescription)

        btnSignIn.tap()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertTrue(titleHomeView.waitForExistence(timeout: 5), app.debugDescription)

    }

    func test_press_on_login_faceid_success() throws {
        let btnLoginFaceId = app.buttons[identifierBtnFaceIdAuthenticationView]
        XCTAssert(btnLoginFaceId.exists)
        btnLoginFaceId.tap()
        print(app.debugDescription)
        acceptPermissionsPromptIfRequired()
        Biometrics.successfulAuthentication()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertTrue(titleHomeView.waitForExistence(timeout: 5), app.debugDescription)

    }

    func test_press_on_login_faceid_failed() throws {
        let btnLoginFaceId = app.buttons[identifierBtnFaceIdAuthenticationView]
        XCTAssert(btnLoginFaceId.exists)
        btnLoginFaceId.tap()
        print(app.debugDescription)
        acceptPermissionsPromptIfRequired()
        Biometrics.unsuccessfulAuthentication()
        let cancelButton = springBoard.alerts.buttons["Cancel"].firstMatch
        XCTAssertTrue(cancelButton.waitForExistence(timeout: 5))
        cancelButton.tap()
        let titleHomeView = app.staticTexts[identifierTitleHomeView]
        XCTAssertFalse(titleHomeView.waitForExistence(timeout: 5), app.debugDescription)
        let infoError = app.staticTexts[identifierErrorAuthentication]
        XCTAssert(infoError.exists)

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

    private func acceptPermissionsPromptIfRequired() {
        let permissionsOkayButton = springBoard.alerts.buttons["OK"].firstMatch
        if permissionsOkayButton.exists {
            permissionsOkayButton.tap()
        }
    }
}
