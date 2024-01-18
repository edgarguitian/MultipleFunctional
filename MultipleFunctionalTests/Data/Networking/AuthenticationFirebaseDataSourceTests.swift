//
//  AuthenticationFirebaseDataSourceTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
class AuthenticationFirebaseDataSourceTests: XCTestCase {

    var dataSource: AuthenticationFirebaseDataSource!

    override func setUp() {
        super.setUp()
        dataSource = AuthenticationFirebaseDataSource()
    }

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    func testLogInEmail() async {
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let validCredentials = LoginCredentials(email: mockEmail, password: mockPassword)

        let expectation = XCTestExpectation(description: "Log in")
        let result = await dataSource.logInEmail(credentials: validCredentials)
        switch result {
        case .success(let userDTO):
            XCTAssertNotNil(userDTO)
        case .failure(let error):
            XCTFail("LogIn failed with error: \(error)")
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)

    }

    func testRegister() async {
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let validCredentials = LoginCredentials(email: mockEmail, password: mockPassword)

        let expectation = XCTestExpectation(description: "Register")
        let result = await dataSource.register(credentials: validCredentials)
        switch result {
        case .success(let userDTO):
            XCTAssertNotNil(userDTO)
        case .failure(let error):
            XCTAssertEqual(error, HTTPClientError.generic)
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testGetCurrentUser() async {
        let expectation = XCTestExpectation(description: "Get Current User")
        let result = await dataSource.getCurrentUser()
        XCTAssertNotNil(result)
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testLogOut() async {
        let expectation = XCTestExpectation(description: "Log Out")
        let result = await dataSource.logOut()
        switch result {
        case .success(let result):
            XCTAssertEqual(result, true)
        case .failure(let error):
            XCTFail("LogOut failed with error: \(error)")
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
