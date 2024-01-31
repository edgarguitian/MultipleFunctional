//
//  DeleteNoteRepositoryType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol DeleteNoteRepositoryType {
    func deleteNote(note: Note) async -> Result<Bool, MultipleFunctionalDomainError>
}
