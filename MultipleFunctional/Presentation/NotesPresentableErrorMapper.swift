//
//  NotesPresentableErrorMapper.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation

class NotesPresentableErrorMapper {
    func map(error: MultipleFunctionalDomainError?) -> String {
        switch error {
        case .errorGetNotes:
            return "Error getting notes. Try again later."
        case .errorDeleteNote:
            return "Error deleting note. Try again later."
        default:
            return "Something went wrong. Try again later."
        }
    }
}
