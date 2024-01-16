//
//  AuthenticationFirebaseDataSourceStub.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import Foundation
@testable import MultipleFunctional

final class AuthenticationFirebaseDataSourceStub: AuthenticationFirebaseDataSourceType {
    private let result: Result<UserDTO, HTTPClientError>

    init(result: Result<UserDTO, HTTPClientError>) {
        self.result = result
    }

    func logIn(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError> {
        return result
    }

    func register(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError> {
        return result
    }

    func getCurrentUser() async -> UserDTO? {
        switch result {
        case .success(let user):
            return user
        case .failure:
            return nil
        }
    }

    func logOut() async -> Result<Bool, HTTPClientError> {
        switch result {
        case .success:
            return .success(true)
        case .failure:
            return .failure(.generic)
        }
    }

}
