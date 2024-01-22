//
//  NotesViewModel.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

final class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var showErrorMessageNote: String?
    @Published var showLoadingSpinner: Bool = true

    private let getNotesUseCase: GetNotesUseCaseType
    private let createNoteUseCase: CreateNoteUseCaseType
    private let deleteNoteUseCase: DeleteNoteUseCaseType

    private let errorMapper: NotesPresentableErrorMapper

    init(getNotesUseCase: GetNotesUseCaseType,
         createNoteUseCase: CreateNoteUseCaseType,
         deleteNoteUseCase: DeleteNoteUseCaseType,
         errorMapper: NotesPresentableErrorMapper) {
        self.getNotesUseCase = getNotesUseCase
        self.createNoteUseCase = createNoteUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.errorMapper = errorMapper
    }

    func getAllNotes() {
        let uiTestErrorHandling = ProcessInfo.processInfo.arguments.contains("UITestErrorHandling")
        if uiTestErrorHandling {
            showErrorMessageNote = "Error al cargar la vista en UITest"
        } else {
            showLoadingSpinner = true
            Task {
                let result = await getNotesUseCase.execute()
                handleResultGetNotes(result)
            }
        }
    }

    func createNewNote(title: String, description: String) {
        if !title.isEmpty && !description.isEmpty {
            Task {
                let result = await createNoteUseCase.execute(title: title, description: description)
                handleResultCreateNote(result)
            }
        } else {
            showErrorMessageNote = NSLocalizedString("errorCreatingNote", comment: "")
        }
    }

    func deleteNote(note: Note) {
        Task {
            if let index = self.notes.firstIndex(where: { $0.id == note.id }) {
                let result = await deleteNoteUseCase.execute(note: note)
                handleResultDeleteNote(result, positionNote: index)
            } else {
                handleError(error: .errorDeleteNote)
            }
        }
    }

    func handleResultGetNotes(_ result: Result<[Note], MultipleFunctionalDomainError>) {
        guard case .success(let notesResult) = result else {
            handleError(error: result.failureValue as? MultipleFunctionalDomainError)
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.notes = notesResult
        }
    }

    func handleResultCreateNote(_ result: Result<Note, MultipleFunctionalDomainError>) {
        guard case .success(let noteResult) = result else {
            handleError(error: result.failureValue as? MultipleFunctionalDomainError)
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.notes.append(noteResult)
        }
    }

    func handleResultDeleteNote(_ result: Result<Bool, MultipleFunctionalDomainError>, positionNote: Int) {
        guard case .success(let noteResult) = result else {
            handleError(error: result.failureValue as? MultipleFunctionalDomainError)
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            if noteResult {
                self.notes.remove(at: positionNote)
            }
        }
    }

    private func handleError(error: MultipleFunctionalDomainError?) {
        Task { @MainActor in
            showLoadingSpinner = false
            showErrorMessageNote = errorMapper.map(error: error)
        }
    }

}
