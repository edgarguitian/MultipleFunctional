//
//  GetNotesRepositoryType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol GetNotesRepositoryType {
    func getAllNotes() async -> Result<[Note], MultipleFunctionalDomainError>
}
