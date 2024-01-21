//
//  Notes.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 21/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Note: Decodable, Identifiable, Encodable {
    @DocumentID var id: String?
    let titulo: String
    let descripcion: String
}
