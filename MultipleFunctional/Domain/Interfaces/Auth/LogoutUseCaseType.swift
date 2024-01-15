//
//  LogoutUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

protocol LogoutUseCaseType {
    func execute() async -> Result<Bool, MultipleFunctionalDomainError>
}
