//
//  GetNotesUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import XCTest
@testable import MultipleFunctional

final class GetNotesUseCaseTests: XCTestCase {

    func test_execute_sucessfully_returns_one_note() async throws {
        // GIVEN
        let mockNote = [
            Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1")
        ]
        let result: Result<[Note], MultipleFunctionalDomainError> = .success(mockNote)
        let stub = GetNotesRepositoryStub(result: result)
        let sut = GetNotesUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN

        let capturedNotesResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedNotesResult.count, mockNote.count)
        XCTAssertEqual(capturedNotesResult.first!.titulo, mockNote.first!.titulo)
        XCTAssertEqual(capturedNotesResult.first!.descripcion, mockNote.first!.descripcion)
    }

    func test_execute_sucessfully_returns_three_note() async throws {
        // GIVEN
        let mockNote = [
            Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1"),
            Note(titulo: "testTitleNote2", descripcion: "testDescriptionNote2"),
            Note(titulo: "testTitleNote3", descripcion: "testDescriptionNote3")
        ]
        let result: Result<[Note], MultipleFunctionalDomainError> = .success(mockNote)
        let stub = GetNotesRepositoryStub(result: result)
        let sut = GetNotesUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN

        let capturedNotesResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedNotesResult.count, mockNote.count)
        XCTAssertEqual(capturedNotesResult.first!.titulo, mockNote.first!.titulo)
        XCTAssertEqual(capturedNotesResult.first!.descripcion, mockNote.first!.descripcion)
        XCTAssertEqual(capturedNotesResult[1].titulo, mockNote[1].titulo)
        XCTAssertEqual(capturedNotesResult[1].descripcion, mockNote[1].descripcion)
        XCTAssertEqual(capturedNotesResult[2].titulo, mockNote[2].titulo)
        XCTAssertEqual(capturedNotesResult[2].descripcion, mockNote[2].descripcion)
    }

    func test_execute_returns_error_when_repository_returns_error() async throws {
        let result: Result<[Note], MultipleFunctionalDomainError> = .failure(.generic)
        let stub = GetNotesRepositoryStub(result: result)
        let sut = GetNotesUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute()

        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

}
