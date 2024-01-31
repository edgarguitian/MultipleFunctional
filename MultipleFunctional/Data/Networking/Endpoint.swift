//
//  Endpoint.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 13/1/24.
//

import Foundation

struct Endpoint {
    let path: String
    let queryParameters: [String: Any]
    let method: HTTPMethod
}
