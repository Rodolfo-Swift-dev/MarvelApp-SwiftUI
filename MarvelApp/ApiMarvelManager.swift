//
//  ApiMarvelManager.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation

class ApiMarvelManager {
    
    /// Método genérico para realizar solicitudes y decodificar la respuesta
    func fetchData(
        request: URLRequest
    ) async throws -> Data {
        
        // Realizar la solicitud
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verificar la respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // devolver los datos
        return data
    }
}
