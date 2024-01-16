//
//  LogoutUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
final class LogoutUseCaseTests: XCTestCase {

    func test_execute_sucessfully_logout() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let user = User(email: mockEmail)
        let result: Result<User, MultipleFunctionalDomainError> = .success(user)
        let stub = AuthRepositoryStub(result: result)
        let sut = LogoutUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN
        let capturedLogoutResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLogoutResult, true)

    }

    func test_execute_returns_error_when_repository_stub_returns_error() async throws {
        // GIVEN
        let result: Result<User, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = AuthRepositoryStub(result: result)
        let sut = LogoutUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)

    }

}
