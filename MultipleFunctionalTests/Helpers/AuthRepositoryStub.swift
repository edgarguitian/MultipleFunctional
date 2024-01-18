//
//  AuthRepositoryStub.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import Foundation
@testable import MultipleFunctional
import FirebaseAuth
class AuthRepositoryStub: AuthRepositoryType {

    private let result: Result<MultipleFunctional.User, MultipleFunctionalDomainError>

    init(result: Result<MultipleFunctional.User, MultipleFunctionalDomainError>) {
        self.result = result
    }

    func logInEmail(credentials: LoginCredentials) async -> Result<MultipleFunctional.User,
                                                                   MultipleFunctionalDomainError> {
        return result
    }

    func logInApple(credentials: AuthCredential) async -> Result<MultipleFunctional.User,
                                                                 MultipleFunctionalDomainError> {
        return result
    }

    func register(credentials: LoginCredentials) async -> Result<MultipleFunctional.User,
                                                                 MultipleFunctionalDomainError> {
        return result
    }

    func getCurrentUser() async -> MultipleFunctional.User? {
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
