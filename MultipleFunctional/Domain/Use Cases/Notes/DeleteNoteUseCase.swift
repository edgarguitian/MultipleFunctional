//
//  DeleteNoteUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

final class DeleteNoteUseCase: DeleteNoteUseCaseType {

    private let repository: NotesRepositoryType

    init(repository: NotesRepositoryType) {
        self.repository = repository
    }

    func execute(note: Note) async -> Result<Bool, MultipleFunctionalDomainError> {
        let result = await repository.deleteNote(note: note)
        guard let noteResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }

            return .failure(error)
        }

        return .success(noteResult)

    }
}
