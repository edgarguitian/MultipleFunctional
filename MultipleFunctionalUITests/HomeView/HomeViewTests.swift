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
    private let identifierSecureFieldPassLogin = "secureFieldPassLoginView"
    private let identifierBtnLoginMailLoginView = "btnLoginEmailLoginView"
    private let identifierTitleHomeView = "titleHomeView"
    private let identifierBtnSubHomeView = "btnShopSubHomeView"
    private let identifierBtnProdHomeView = "btnShopProdHomeView"
    private let identifierImageBtnProdHome = "imageBtnProd"
    private let identifierBtnActiveSubscriptionHomeView = "btnSubscriptionActiveHomeView"
    private let identifierTitleAuthenticationView = "textTitleAuthenticationView"

    private let identifierSubscriptionStore = "Subscription Store View Button"
    private let identifierSubscriptionClose = "Close"

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

    func test_home_view_screen_show() throws {
        XCTAssert(app.staticTexts[identifierTitleHomeView].exists)
        XCTAssert(app.buttons[identifierBtnSubHomeView].exists)
        XCTAssert(app.otherElements[identifierBtnProdHomeView].exists)
        XCTAssert(app.buttons[identifierBtnLogout].exists)
    }

    func test_buy_suscription_yearly_success() throws {
        let btnSub = app.buttons[identifierBtnSubHomeView]
        XCTAssert(btnSub.exists)
        btnSub.tap()
        let btnBuySub = app.buttons[identifierSubscriptionStore]
        XCTAssert(btnBuySub.waitForExistence(timeout: 5))
        btnBuySub.tap()
        let springBoard =  XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let btnPurchase = springBoard.buttons["Subscribe"]
        XCTAssert(btnPurchase.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnPurchase.tap()
        let btnOK = springBoard.buttons["OK"]
        XCTAssert(btnOK.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnOK.tap()
        print(app.debugDescription)
        let btnClose = app.buttons[identifierSubscriptionClose]
        XCTAssert(btnClose.waitForExistence(timeout: 5), app.debugDescription)
        btnClose.tap()
        let btnHandleSub = app.buttons[identifierBtnActiveSubscriptionHomeView]
        XCTAssert(btnHandleSub.waitForExistence(timeout: 5), app.debugDescription)

    }

    func test_buy_suscription_monthly_success() throws {
        let btnSub = app.buttons[identifierBtnSubHomeView]
        XCTAssert(btnSub.exists)
        btnSub.tap()

        let btnBuySub = app.buttons[identifierSubscriptionStore]
        XCTAssert(btnBuySub.waitForExistence(timeout: 5))
        print(app.debugDescription)
        let identifierMonthlyButton = "Subscription Store View Default Picker Item"
        let descriptionMonthlyButton = "Monthly, 3 days free, then $4.99 per month, Unlock all the content"
        let formatMonthlyButton = "identifier == %@ AND label == %@"
        let predicate = NSPredicate(format: formatMonthlyButton, identifierMonthlyButton, descriptionMonthlyButton)
        let monthlyButton = app.buttons.matching(predicate).element
        XCTAssert(monthlyButton.exists)

        monthlyButton.tap()
        btnBuySub.tap()
        let springBoard =  XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let btnPurchase = springBoard.buttons["Subscribe"]
        XCTAssert(btnPurchase.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnPurchase.tap()
        let btnOK = springBoard.buttons["OK"]
        XCTAssert(btnOK.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnOK.tap()
        print(app.debugDescription)
        let btnClose = app.buttons[identifierSubscriptionClose]
        XCTAssert(btnClose.waitForExistence(timeout: 5), app.debugDescription)
        btnClose.tap()
        let btnHandleSub = app.buttons[identifierBtnActiveSubscriptionHomeView]
        XCTAssert(btnHandleSub.waitForExistence(timeout: 5), app.debugDescription)

    }

    func test_buy_product_success() throws {
        let btnProd = app.otherElements[identifierBtnProdHomeView]
        XCTAssert(btnProd.exists)
        btnProd.tap()
        let springBoard =  XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let btnPurchase = springBoard.buttons["Purchase"]
        XCTAssert(btnPurchase.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnPurchase.tap()
        let btnOK = springBoard.buttons["OK"]
        XCTAssert(btnOK.waitForExistence(timeout: 5), springBoard.debugDescription)
        btnOK.tap()
        let imageBtnProd = app.images[identifierImageBtnProdHome]
        XCTAssert(imageBtnProd.waitForExistence(timeout: 5), app.debugDescription)
        XCTAssertEqual(imageBtnProd.label, "crown.fill")

    }

    func test_logout() throws {
        let btnLogout = app.buttons[identifierBtnLogout]
        XCTAssert(btnLogout.exists)
        btnLogout.tap()
        XCTAssert(app.staticTexts[identifierTitleAuthenticationView].waitForExistence(timeout: 5))
    }

}
