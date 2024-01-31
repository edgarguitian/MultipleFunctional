//
//  HTTPClientError.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 13/1/24.
//

import Foundation

enum HTTPClientError: Error {
    case clientError
    case serverError
    case generic
    case parsingError
    case badURL
    case responseError
    case tooManyRequests
    case emptyAuthLoginMail
    case noUser
    case wrongPassword
    case userNotFound
}
