//
//  CreateNoteUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol CreateNoteUseCaseType {
    func execute(title: String, description: String) async -> Result<Note, MultipleFunctionalDomainError>
}
