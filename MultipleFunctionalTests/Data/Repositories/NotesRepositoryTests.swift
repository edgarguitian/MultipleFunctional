//
//  NotesRepositoryTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import XCTest
@testable import MultipleFunctional
import FirebaseFirestore
import FirebaseFirestoreSwift

final class NotesRepositoryTests: XCTestCase {
    var notesRepository: NotesRepository!
    var initialNote: Note!

    override func setUpWithError() throws {
        super.setUp()

        // Initialize NotesRepository with MockErrorMapper
        notesRepository = NotesRepository(errorMapper: MultipleFunctionalDomainErrorMapper())
        initialNote = Note(titulo: "Test Title", descripcion: "Test Description")
        let dataBaseName = MultipleFunctional.Constants.databaseFirestoreName
        _ = try Firestore.firestore().collection(dataBaseName).addDocument(from: initialNote)
    }

    override func tearDownWithError() throws {
        notesRepository = nil
        super.tearDown()
    }

    func test_getAllNotes_returns_all_notes() async throws {
        // WHEN
        let result = await notesRepository.getAllNotes()

        // THEN
        switch result {
        case .success(let notes):
            XCTAssertEqual(notes.count, 1)
            XCTAssertEqual(notes[0].titulo, "Test Title")
            XCTAssertEqual(notes[0].descripcion, "Test Description")
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }

    func test_createNewNote_return_note_created() async throws {
        // GIVEN
        let mockTitle = "Test New Title"
        let mockDescription = "Test New Description"

        // WHEN
        let result = await notesRepository.createNewNote(title: mockTitle, description: mockDescription)

        // Assert the result
        switch result {
        case .success(let note):
            XCTAssertEqual(note.titulo, mockTitle)
            XCTAssertEqual(note.descripcion, mockDescription)
        case .failure:
            XCTFail("Expected success, but got failure.")
        }
    }

    func test_deleteNote_successfully_delete_note() async throws {
        // GIVEN
        let resultGet = await notesRepository.getAllNotes()
        guard let notes = try? resultGet.get() else {
            XCTFail("Not Notes in Firestore")
            return
        }

        // WHEN
        guard let firstNote = notes.first else {
            XCTFail("Not Notes in Firestore")
            return
        }
        let result = await notesRepository.deleteNote(note: firstNote)

        // THEN
        switch result {
        case .success(let note):
            XCTAssertEqual(note, true)
        case .failure:
            XCTFail("Failure on delete note.")
        }
    }
}
