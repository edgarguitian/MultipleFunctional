//
//  RegisterUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
final class RegisterUseCaseTests: XCTestCase {

    func test_execute_sucessfully_returns_register_user() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let user = User(email: mockEmail)
        let result: Result<User, MultipleFunctionalDomainError> = .success(user)
        let stub = AuthRepositoryStub(result: result)
        let sut = RegisterUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN

        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)

    }

    func test_execute_returns_error_when_repository_returns_error() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "abc"

        let result: Result<User, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = AuthRepositoryStub(result: result)
        let sut = RegisterUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }
        let errorDescription = "The operation couldn’t be completed. " +
        "(MultipleFunctional.MultipleFunctionalDomainError error 0.)"
        XCTAssertEqual(error.localizedDescription, errorDescription)
    }

}
