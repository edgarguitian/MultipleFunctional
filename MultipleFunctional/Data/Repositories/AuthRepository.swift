//
//  AuthRepository.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation
import FirebaseAuth

final class AuthRepository: AuthRepositoryType {

    private let authenticationFirebaseDatasource: AuthenticationFirebaseDataSourceType
    private let errorMapper: MultipleFunctionalDomainErrorMapper

    init(authenticationFirebaseDatasource: AuthenticationFirebaseDataSourceType,
         errorMapper: MultipleFunctionalDomainErrorMapper) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
        self.errorMapper = errorMapper
    }

    func logInEmail(credentials: LoginCredentials) async -> Result<User, Error> {
        let result = await authenticationFirebaseDatasource.logInEmail(credentials: credentials)
        guard case .success(let loginResult) = result else {
            return .failure(result.failureValue!)
        }

        return .success(User(response: loginResult))
    }

    func logInApple(credentials: AuthCredential) async -> Result<User, MultipleFunctionalDomainError> {
        let result = await authenticationFirebaseDatasource.logInApple(credentials: credentials)
        guard case .success(let loginResult) = result else {
            return .failure(errorMapper.map(error: result.failureValue as? HTTPClientError))
        }

        return .success(User(response: loginResult))
    }

    func register(credentials: LoginCredentials) async -> Result<User, Error> {
        let result = await authenticationFirebaseDatasource.register(credentials: credentials)
        guard case .success(let loginResult) = result else {
            return .failure(result.failureValue!)
        }

        return .success(User(response: loginResult))
    }

    func getCurrentUser() async -> User? {
        let result = await authenticationFirebaseDatasource.getCurrentUser()
        guard let loginResult = result else {
            return nil
        }

        return User(response: loginResult)
    }

    func logOut() async -> Result<Bool, MultipleFunctionalDomainError> {
        let result = await authenticationFirebaseDatasource.logOut()

        switch result {
            case .success:
                return .success(true)
            case .failure(let error):
                return .failure(errorMapper.map(error: error))
            }

    }

    private func handleError(error: HTTPClientError?) -> HTTPClientError {
        guard let error = error else {
            return .generic
        }

        return error
    }

}
