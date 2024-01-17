//
//  LoggerAdapter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import Foundation
import OSLog

protocol Logging {
    func log(_ message: String)
}

class LoggerAdapter: Logging {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func log(_ message: String) {
        logger.log("\(message)")
    }
}
