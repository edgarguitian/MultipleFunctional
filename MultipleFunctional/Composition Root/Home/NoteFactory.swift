//
//  NoteFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

class NoteFactory: CreateNoteView {
    lazy var sharedNotesRepository: NotesRepository = createNotesRepository()

    func create() -> NoteView {
        return NoteView(viewModel: createNoteViewModel())
    }

    private func createNoteViewModel() -> NotesViewModel {
        return NotesViewModel(getNotesUseCase: createGetNotesUseCase(),
                              createNoteUseCase: createNewNoteUseCase(),
                              deleteNoteUseCase: createDeleteNoteUseCase(),
                              errorMapper: NotesPresentableErrorMapper())
    }

    private func createGetNotesUseCase() -> GetNotesUseCaseType {
        return GetNotesUseCase(repository: sharedNotesRepository)
    }

    private func createNewNoteUseCase() -> CreateNoteUseCaseType {
        return CreateNoteUseCase(repository: sharedNotesRepository)
    }

    private func createDeleteNoteUseCase() -> DeleteNoteUseCaseType {
        return DeleteNoteUseCase(repository: sharedNotesRepository)
    }

    private func createNotesRepository() -> NotesRepository {
        return NotesRepository(errorMapper: MultipleFunctionalDomainErrorMapper())
    }
}
