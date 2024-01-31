//
//  DeleteNoteUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import XCTest
@testable import MultipleFunctional

final class DeleteNoteUseCaseTests: XCTestCase {

    func test_execute_sucessfully_delete_note() async throws {
        // GIVEN
        let mockNote = [
            Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1")
        ]
        let result: Result<Bool, MultipleFunctionalDomainError> = .success(true)
        let stub = DeleteNoteRepositoryStub(result: result)
        let sut = DeleteNoteUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(note: mockNote[0])

        // THEN
        let capturedNoteResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedNoteResult, true)
    }

    func test_execute_returns_false_when_repository_returns_false() async throws {
        // GIVEN
        let mockNote = [
            Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1")
        ]
        let result: Result<Bool, MultipleFunctionalDomainError> = .success(false)
        let stub = DeleteNoteRepositoryStub(result: result)
        let sut = DeleteNoteUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(note: mockNote[0])

        // THEN
        let capturedNoteResult = try XCTUnwrap(capturedResult.get())
        XCTAssertEqual(capturedNoteResult, false)
    }

    func test_execute_returns_error_when_repository_returns_error() async throws {
        // GIVEN
        let mockNote = [
            Note(titulo: "testTitleNote1", descripcion: "testDescriptionNote1")
        ]
        let result: Result<Bool, MultipleFunctionalDomainError> = .failure(.generic)
        let stub = DeleteNoteRepositoryStub(result: result)
        let sut = DeleteNoteUseCase(repository: stub)

        // WHEN
        let capturedResult = await sut.execute(note: mockNote[0])
        // THEN
        guard case .failure(let error) = capturedResult else {
            XCTFail("Expected failure, got success")
            return
        }

        XCTAssertEqual(error, MultipleFunctionalDomainError.generic)
    }

}
