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
        XCTAssert(app.staticTexts[identifierTitleHomeView].exists)

    }

    func test_notes_view_screen_show() throws {
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

    func test_create_note_success() throws {
        let tabNotes = app.buttons[identifierTabNotes]
        XCTAssert(tabNotes.exists, app.debugDescription)
        tabNotes.tap()
        let fieldTitle = app.textViews[identifierNewNoteTitleField]
        XCTAssert(fieldTitle.waitForExistence(timeout: 5), app.debugDescription)
        print(app.debugDescription)
        fieldTitle.tap()
        let titleNote = "Test Tittle Note UI"
        fieldTitle.typeText(titleNote)
        let fieldDesc = app.textViews[identifierNewNoteDescField]
        XCTAssert(fieldDesc.exists, app.debugDescription)
        fieldDesc.tap()
        fieldDesc.typeText("Test Desc Note UI")
        let btnCreate = app.buttons[identifierBtnNewNote]
        XCTAssert(btnCreate.exists, app.debugDescription)
        btnCreate.tap()
        let stackNoteElements = app.staticTexts.matching(identifier: identifierContainerNote)

        for stackNoteElement in 0..<stackNoteElements.count {
            let stackNote = stackNoteElements.element(boundBy: stackNoteElement)

            XCTAssertTrue(stackNote.exists)

            if stackNote.label == titleNote {
                XCTAssert(true, "Se encontró un elemento con el label 'Test Tittle Note UI'")
                return
            }
        }

        XCTAssert(false, "No se encontró ningún elemento con el label 'Test Tittle Note UI'")
    }

    func test_create_note_empty() throws {
        let tabNotes = app.buttons[identifierTabNotes]
        XCTAssert(tabNotes.exists, app.debugDescription)
        tabNotes.tap()
        let fieldTitle = app.textViews[identifierNewNoteTitleField]
        XCTAssert(fieldTitle.waitForExistence(timeout: 5), app.debugDescription)
        print(app.debugDescription)
        fieldTitle.tap()
        let titleNote = ""
        fieldTitle.typeText(titleNote)
        let fieldDesc = app.textViews[identifierNewNoteDescField]
        XCTAssert(fieldDesc.exists, app.debugDescription)
        fieldDesc.tap()
        fieldDesc.typeText("Test Desc Note UI")
        let btnCreate = app.buttons[identifierBtnNewNote]
        XCTAssert(btnCreate.exists, app.debugDescription)
        btnCreate.tap()
        let errorMessage = app.staticTexts[identifierMessageErrorNote]
        XCTAssert(errorMessage.waitForExistence(timeout: 5), app.debugDescription)
    }

    func test_delete_note() throws {
        let tabNotes = app.buttons[identifierTabNotes]
        XCTAssert(tabNotes.exists, app.debugDescription)
        tabNotes.tap()
        let titleNote = "Test Tittle Note UI"
        let btnDeleteNote = app.buttons[identifierBtnDeleteNote]
        XCTAssertFalse(btnDeleteNote.waitForExistence(timeout: 5), app.debugDescription)

        let stackNoteElements = app.staticTexts.matching(identifier: identifierContainerNote)

        for stackNoteElement in 0..<stackNoteElements.count {
            let stackNote = stackNoteElements.element(boundBy: stackNoteElement)

            XCTAssertTrue(stackNote.exists)

            if stackNote.label == titleNote {
                stackNote.swipeLeft()
                XCTAssert(btnDeleteNote.waitForExistence(timeout: 5), app.debugDescription)
                btnDeleteNote.tap()
                checkElementWasDeleted(title: titleNote)
                return
            }
        }

        XCTAssert(false, "No se encontró ningún elemento con el label 'Test Tittle Note UI'")
    }

    func checkElementWasDeleted(title: String) {
        let stackNoteElements = app.staticTexts.matching(identifier: identifierContainerNote)

        for stackNoteElement in 0..<stackNoteElements.count {
            let stackNote = stackNoteElements.element(boundBy: stackNoteElement)

            XCTAssertTrue(stackNote.exists)

            if stackNote.label == title {
                XCTAssert(false, "Se encontró un elemento con el label \(title)")
                return
            }
        }

        XCTAssert(true, "No se encontró ningún elemento con el label \(title)")
    }
}
