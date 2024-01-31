//
//  NotesRepository.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class NotesRepository {

    private let errorMapper: MultipleFunctionalDomainErrorMapper
    let database: Firestore
    private let collection = Constants.databaseFirestoreName

    init(errorMapper: MultipleFunctionalDomainErrorMapper, database: Firestore = Firestore.firestore()) {
        self.errorMapper = errorMapper
        self.database = database
    }
}

extension NotesRepository: GetNotesRepositoryType {
    func getAllNotes() async -> Result<[Note], MultipleFunctionalDomainError> {
        var notes = [Note]()

        do {
            let querySnapshot = try await database.collection(collection).getDocuments()

            for document in querySnapshot.documents {
                let data = document.data()
                let id = document.documentID
                guard let title = data["titulo"] as? String,
                      let description = data["descripcion"] as? String else {
                    return .failure(.errorGetNotes)
                }

                let note = Note(id: id, titulo: title, descripcion: description)
                notes.append(note)
            }

            return .success(notes)
        } catch let error as HTTPClientError {
            return .failure(errorMapper.map(error: error))
        } catch {
            return .failure(.generic)
        }
    }
}

extension NotesRepository: CreateNoteRepositoryType {
    func createNewNote(title: String, description: String) async -> Result<Note, MultipleFunctionalDomainError> {
        do {
            let note = Note(titulo: title, descripcion: description)
            _ = try database.collection(collection).addDocument(from: note)
            return .success(note)
        } catch let error as HTTPClientError {
            return .failure(errorMapper.map(error: error))
        } catch {
            return .failure(.generic)
        }
    }
}

extension NotesRepository: DeleteNoteRepositoryType {
    func deleteNote(note: Note) async -> Result<Bool, MultipleFunctionalDomainError> {
        guard let documentId = note.id else {
            return .failure(.errorDeleteNote)
        }
        do {
            try await database.collection(collection).document(documentId).delete()
            return .success(true)
        } catch {
            return .success(false)
        }
    }
}
