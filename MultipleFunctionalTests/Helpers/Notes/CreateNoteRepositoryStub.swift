//
//  CreateNoteRepositoryStub.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation
@testable import MultipleFunctional

class CreateNoteRepositoryStub: CreateNoteRepositoryType {
    private let result: Result<Note, MultipleFunctionalDomainError>

    init(result: Result<Note, MultipleFunctionalDomainError>) {
        self.result = result
    }

    func createNewNote(title: String, description: String) async -> Result<Note, MultipleFunctionalDomainError> {
        return result
    }

}
