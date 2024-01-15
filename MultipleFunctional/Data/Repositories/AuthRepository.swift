//
//  AuthRepository.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class AuthRepository: AuthRepositoryType {

    private let authenticationFirebaseDatasource: AuthenticationFirebaseDataSourceType
    private let errorMapper: MultipleFunctionalDomainErrorMapper

    init(authenticationFirebaseDatasource: AuthenticationFirebaseDataSourceType,
         errorMapper: MultipleFunctionalDomainErrorMapper) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
        self.errorMapper = errorMapper
    }

    func logIn(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError> {
        let result = await authenticationFirebaseDatasource.logIn(credentials: credentials)
        guard case .success(let loginResult) = result else {
            return .failure(errorMapper.map(error: result.failureValue as? HTTPClientError))
        }

        return .success(User(response: loginResult))
    }

    func register(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError> {
        let result = await authenticationFirebaseDatasource.register(credentials: credentials)
        guard case .success(let loginResult) = result else {
            return .failure(errorMapper.map(error: result.failureValue as? HTTPClientError))
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
        guard case .success(_) = result else {
            return .failure(errorMapper.map(error: result.failureValue as? HTTPClientError))
        }

        return .success(true)

    }

    private func handleError(error: HTTPClientError?) -> HTTPClientError {
        guard let error = error else {
            return .generic
        }

        return error
    }

}
