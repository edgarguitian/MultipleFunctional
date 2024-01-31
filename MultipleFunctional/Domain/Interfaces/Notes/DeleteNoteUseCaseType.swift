//
//  DeleteNoteUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol DeleteNoteUseCaseType {
    func execute(note: Note) async -> Result<Bool, MultipleFunctionalDomainError>
}
