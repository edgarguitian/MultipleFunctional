//
//  LoginAppleUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 18/1/24.
//

import XCTest
@testable import MultipleFunctional
import FirebaseAuth

final class LoginAppleUseCaseTests: XCTestCase {

    func test_execute_sucesfully_returns_login_user_stub() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let appleCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                       idToken: String(data: Data(), encoding: .utf8)!,
                                                       rawNonce: nil)
        let user = MultipleFunctional.User(email: mockEmail)
        let result: Result<MultipleFunctional.User, MultipleFunctionalDomainError> = .success(user)
        let stub = AuthRepositoryStub(result: result)
        let sut = LoginAppleUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(credential: appleCredential)

        // THEN

        let capturedLoginResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedLoginResult.email, mockEmail)
    }

    func test_execute_returns_error_when_repository_stub_returns_error() async throws {
        // GIVEN
        let mockEmail = "test@gmail.com"
        let appleCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                       idToken: String(data: Data(), encoding: .utf8)!,
                                                       rawNonce: nil)
        let result: Result<MultipleFunctional.User, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = AuthRepositoryStub(result: result)
        let sut = LoginAppleUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(credential: appleCredential)

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

}
