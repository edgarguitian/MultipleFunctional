//
//  NotesRepositoryType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol NotesRepositoryType {
    func getAllNotes() async -> Result<[Note], MultipleFunctionalDomainError>
    func createNewNote(title: String, description: String) async -> Result<Note, MultipleFunctionalDomainError>
    func deleteNote(note: Note) async -> Result<Bool, MultipleFunctionalDomainError>
}
