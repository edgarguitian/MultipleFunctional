//
//  LoginUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
final class LoginUseCaseTests: XCTestCase {

    func test_execute_sucessfully_returns_login_user() async throws {
        // GIVEN
        let mockEmail = "edguitian@gmail.com"
        let mockPassword = "test123"

        let stub = AuthRepository(authenticationFirebaseDatasource: AuthenticationFirebaseDataSource(),
                                  errorMapper: MultipleFunctionalDomainErrorMapper())
        let sut = LoginUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN

        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)

    }

    func test_execute_returns_error_when_repository_returns_error() async throws {
        // GIVEN
        let mockEmail = "edguitian@gmail.com"
        let mockPassword = "abc"

        let stub = AuthRepository(authenticationFirebaseDatasource: AuthenticationFirebaseDataSource(),
                                  errorMapper: MultipleFunctionalDomainErrorMapper())
        let sut = LoginUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

    func test_execute_sucesfully_returns_login_user_stub() async throws {
        // GIVEN
        let mockEmail = "edguitian@gmail.com"
        let mockPassword = "test123"

        let user = User(email: mockEmail)
        let result: Result<User, MultipleFunctionalDomainError> = .success(user)
        let stub = AuthRepositoryStub(result: result)
        let sut = LoginUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN

        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)
    }

    func test_execute_returns_error_when_repository_stub_returns_error() async throws {
        // GIVEN
        let mockEmail = "edguitian@gmail.com"
        let mockPassword = "abc"

        let result: Result<User, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = AuthRepositoryStub(result: result)
        let sut = LoginUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(email: mockEmail, password: mockPassword)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

}
