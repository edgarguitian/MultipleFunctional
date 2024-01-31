//
//  GetUserUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class GetUserUseCase: GetUserUseCaseType {
    private let repository: AuthRepositoryType

    init(repository: AuthRepositoryType) {
        self.repository = repository
    }

    func execute() async -> User? {
        let result = await repository.getCurrentUser()
        guard let loginResult = result else {
            return nil
        }

        return loginResult

    }
}
