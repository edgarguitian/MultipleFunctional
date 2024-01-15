//
//  RegisterUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class RegisterUseCase: RegisterUseCaseType {
    private let repository: AuthRepositoryType

    init(repository: AuthRepositoryType) {
        self.repository = repository
    }

    func execute(email: String, password: String) async -> Result<User, MultipleFunctionalDomainError> {
        let credential = LoginCredentials(email: email, password: password)
        let result = await repository.register(credentials: credential)

        guard let loginResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(loginResult)

    }
}
