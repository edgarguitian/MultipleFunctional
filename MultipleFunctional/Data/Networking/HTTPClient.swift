//
//  HTTPClient.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 13/1/24.
//

import Foundation

protocol HTTPClient {
    func makeRequest(endpoint: Endpoint, baseUrl: String) async -> Result<Data, HTTPClientError>
}
