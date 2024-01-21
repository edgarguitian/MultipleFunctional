//
//  CreateNoteUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import XCTest
@testable import MultipleFunctional

final class CreateNoteUseCaseTests: XCTestCase {

    func test_execute_sucessfully_create_note() async throws {
        // GIVEN
        let mockNote = Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1")
        let result: Result<Note, MultipleFunctionalDomainError> = .success(mockNote)
        let stub = CreateNoteRepositoryStub(result: result)
        let sut = CreateNoteUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(title: "", description: "")

        // THEN
        let capturedNoteResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedNoteResult.titulo, mockNote.titulo)
        XCTAssertEqual(capturedNoteResult.descripcion, mockNote.descripcion)
    }

    func test_execute_returns_error_when_repository_returns_error() async throws {
        // GIVEN
        let result: Result<Note, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = CreateNoteRepositoryStub(result: result)
        let sut = CreateNoteUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(title: "", description: "")

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

}
