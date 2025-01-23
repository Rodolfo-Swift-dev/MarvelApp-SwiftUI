//
//  ApiMarvelService.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation

class ApiMarvelService {
    let builder = ApiRequestBuilder()
    let apiManager = ApiMarvelManager()
    let decoder = Decoder()
    
    func fetchData<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type,
        parameter: [String: String] = [:]
    ) async throws -> T  {
        
        if parameter != [:], let request = builder.buildRequest(for: endpoint, parameters: parameter) {
            
            let data = try await apiManager.fetchData(request: request)
            return try decoder.jsonDecoder.decode(responseType, from: data)
           
        } else if let request = builder.buildRequest(for: endpoint) {
            
            let data = try await apiManager.fetchData(request: request)
            return try decoder.jsonDecoder.decode(responseType, from: data)
            
        } else {
            throw URLError(.badURL)
        }
        
       
    }
    
    
}
