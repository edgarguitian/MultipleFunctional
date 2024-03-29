//
//  LogoutUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class LogoutUseCase: LogoutUseCaseType {
    private let repository: AuthRepositoryType

    init(repository: AuthRepositoryType) {
        self.repository = repository
    }

    func execute() async -> Result<Bool, MultipleFunctionalDomainError> {
        let result = await repository.logOut()

        guard let loginResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(loginResult)

    }
}
