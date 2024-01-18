//
//  LoginAppleUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 18/1/24.
//

import Foundation
import FirebaseAuth

final class LoginAppleUseCase: LoginAppleUseCaseType {
    private let repository: AuthRepositoryType

    init(repository: AuthRepositoryType) {
        self.repository = repository
    }

    func execute(credential: AuthCredential) async -> Result<User, MultipleFunctionalDomainError> {
        let result = await repository.logInApple(credentials: credential)

        guard let loginResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(loginResult)

    }
}
