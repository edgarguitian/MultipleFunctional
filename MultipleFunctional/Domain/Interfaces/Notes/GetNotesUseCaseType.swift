//
//  GetNotesUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

protocol GetNotesUseCaseType {
    func execute() async -> Result<[Note], MultipleFunctionalDomainError>
}
