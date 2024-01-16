//
//  AuthRepositoryStub.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import Foundation
@testable import MultipleFunctional
class AuthRepositoryStub: AuthRepositoryType {
    private let result: Result<User, MultipleFunctionalDomainError>

    init(result: Result<User, MultipleFunctionalDomainError>) {
        self.result = result
    }

    func logIn(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError> {
        return result
    }

    func register(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError> {
        return result
    }

    func getCurrentUser() async -> User? {
        switch result {
        case .success(let user):
            return user
        case .failure:
            return nil
        }
    }

    func logOut() async -> Result<Bool, MultipleFunctionalDomainError> {
        switch result {
        case .success:
            return .success(true)
        case .failure:
            return .failure(.generic)
        }
    }

}
