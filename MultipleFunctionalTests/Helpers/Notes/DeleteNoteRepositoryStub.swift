//
//  DeleteNoteRepositoryStub.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation
@testable import MultipleFunctional

class DeleteNoteRepositoryStub: DeleteNoteRepositoryType {
    private let result: Result<Bool, MultipleFunctionalDomainError>

    init(result: Result<Bool, MultipleFunctionalDomainError>) {
        self.result = result
    }

    func deleteNote(note: Note) async -> Result<Bool, MultipleFunctionalDomainError> {
        return result
    }

}
