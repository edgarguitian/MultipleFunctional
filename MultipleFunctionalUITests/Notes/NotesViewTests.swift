//
//  NotesViewTests.swift
//  MultipleFunctionalUITests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import XCTest

final class NotesViewTests: XCTestCase {
    private var app: XCUIApplication!
    private let identifierBtnLogout = "btnLogout"
    private let identifierBtnLoginMailAuthenticationView = "btnLoginMailAuthenticationView"
    private let identifierGroupTitleLoginView = "groupTitleLoginView"
    private let identifierFieldEmailLoginView = "fieldEmailLoginView"
    private let identifierSecureFieldPassLogin = "secureFieldPassLoginView"
    private let identifierBtnLoginMailLoginView = "btnLoginEmailLoginView"
    private let identifierTitleHomeView = "titleHomeView"
    private let identifierTabNotes = "tabNotes"
    private let identifierNewNoteTitleInfo = "newNoteTitleInfo"
    private let identifierNewNoteTitleField = "newNoteTitleField"
    private let identifierNewNoteDescInfo = "newNoteDescInfo"
    private let identifierNewNoteDescField = "newNoteDescField"
    private let identifierBtnNewNote = "btnNewNote"
    private let identifierMessageErrorNote = "noteViewErrorMessage"
    private let identifierListNotes = "listNotes"
    private let identifierLoadingListNotes = "loadingListNotes"
    private let identifierBtnDeleteNote = "btnDeleteNote"
    private let identifierContainerNote = "stackNote"

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

    func test_notes_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierTitleHomeView].exists)
        let tabNotes = app.buttons[identifierTabNotes]
        XCTAssert(tabNotes.exists, app.debugDescription)
        tabNotes.tap()
        XCTAssertTrue(app.staticTexts[identifierNewNoteTitleInfo].waitForExistence(timeout: 5), app.debugDescription)
        XCTAssert(app.staticTexts[identifierNewNoteDescInfo].exists, app.debugDescription)
        XCTAssert(app.textViews[identifierNewNoteTitleField].exists, app.debugDescription)
        XCTAssert(app.textViews[identifierNewNoteDescField].exists, app.debugDescription)
        XCTAssert(app.buttons[identifierBtnNewNote].exists, app.debugDescription)
        XCTAssert(app.collectionViews[identifierListNotes].exists, app.debugDescription)

    }
}
