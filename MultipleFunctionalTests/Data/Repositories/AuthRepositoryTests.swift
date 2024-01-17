//
//  AuthRepositoryTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import XCTest
@testable import MultipleFunctional
final class AuthRepositoryTests: XCTestCase {

    func test_logIn_returns_success_login_user() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSource()
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logIn(credentials: loginCredentialsMock)

        // THEN
        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)
    }

    func test_logIn_returns_success_login_user_stub() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let user = UserDTO(email: mockEmail)
        let result: Result<UserDTO, HTTPClientError> = .success(user)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logIn(credentials: loginCredentialsMock)

        // THEN
        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)
    }

    func test_logIn_returns_failure_when_authDataSource_fails() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "abc"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSource()
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logIn(credentials: loginCredentialsMock)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

    func test_logIn_returns_failure_when_authDataSource_fails_stub() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let result: Result<UserDTO, HTTPClientError> = .failure(.generic)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logIn(credentials: loginCredentialsMock)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

    func test_register_returns_success_register_user() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let user = UserDTO(email: mockEmail)
        let result: Result<UserDTO, HTTPClientError> = .success(user)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.register(credentials: loginCredentialsMock)

        // THEN
        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)
    }

    func test_register_returns_failure_when_authDataSource_fails_stub() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let mockPassword = "test123"
        let loginCredentialsMock = LoginCredentials(email: mockEmail, password: mockPassword)
        let result: Result<UserDTO, HTTPClientError> = .failure(.generic)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.register(credentials: loginCredentialsMock)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

    func test_getCurrentUser_returns_success_user() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let user = UserDTO(email: mockEmail)
        let result: Result<UserDTO, HTTPClientError> = .success(user)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.getCurrentUser()

        // THEN
        XCTAssertEqual(capturedResult, User(response: user))
    }

    func test_getCurrentUser_returns_failure_when_authDataSource_fails_stub() async throws {
        // GIVEN
        let result: Result<UserDTO, HTTPClientError> = .failure(.generic)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.getCurrentUser()

        // THEN
        XCTAssertEqual(capturedResult, nil)
    }

    func test_logOut_returns_success_logout() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let user = UserDTO(email: mockEmail)
        let result: Result<UserDTO, HTTPClientError> = .success(user)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logOut()

        // THEN
        let capturedLogoutResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLogoutResult, true)
    }

    func test_logOut_returns_failure_when_authDataSource_fails_stub() async throws {
        // GIVEN
        let result: Result<UserDTO, HTTPClientError> = .failure(.generic)
        let authenticationFirebaseDataSource = AuthenticationFirebaseDataSourceStub(result: result)
        let sut = AuthRepository(authenticationFirebaseDatasource: authenticationFirebaseDataSource,
                                 errorMapper: MultipleFunctionalDomainErrorMapper())

        // WHEN
        let capturedResult = await sut.logOut()

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }
}
