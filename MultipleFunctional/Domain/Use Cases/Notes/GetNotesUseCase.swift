//
//  GetNotesUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

final class GetNotesUseCase: GetNotesUseCaseType {
    private let repository: GetNotesRepositoryType

    init(repository: GetNotesRepositoryType) {
        self.repository = repository
    }

    func execute() async -> Result<[Note], MultipleFunctionalDomainError> {
        let result = await repository.getAllNotes()
        guard let notesResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(notesResult)

    }
}
