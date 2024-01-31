//
//  CreateNoteUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

final class CreateNoteUseCase: CreateNoteUseCaseType {

    private let repository: CreateNoteRepositoryType

    init(repository: CreateNoteRepositoryType) {
        self.repository = repository
    }

    func execute(title: String, description: String) async -> Result<Note, MultipleFunctionalDomainError> {
        let result = await repository.createNewNote(title: title,
                                                    description: description)
        guard let noteResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(noteResult)

    }
}
