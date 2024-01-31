//
//  LoginEmailUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class LoginEmailUseCase: LoginEmailUseCaseType {
    private let repository: AuthRepositoryType

    init(repository: AuthRepositoryType) {
        self.repository = repository
    }

    func execute(email: String, password: String) async -> Result<User, Error> {
        let credential = LoginCredentials(email: email, password: password)
        let result = await repository.logInEmail(credentials: credential)

        guard let loginResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(result.failureValue!)
            }

            return .failure(error)
        }

        return .success(loginResult)

    }
}
