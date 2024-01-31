//
//  GetUserUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
final class GetUserUseCaseTests: XCTestCase {

    func test_execute_sucessfully_returns_user() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let user = User(email: mockEmail)
        let result: Result<User, MultipleFunctionalDomainError> = .success(user)
        let stub = AuthRepositoryStub(result: result)
        let sut = GetUserUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN
        XCTAssertEqual(capturedResult, user)

    }

    func test_execute_returns_nil_when_no_exist_user() async throws {
        // GIVEN
        let result: Result<User, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = AuthRepositoryStub(result: result)
        let sut = GetUserUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN
        XCTAssertEqual(capturedResult, nil)

    }

}
