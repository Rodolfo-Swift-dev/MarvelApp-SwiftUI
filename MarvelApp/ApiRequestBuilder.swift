//
//  ApiRequestBuilder.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation

enum Endpoint {
    case allEvents
    case comicsByEvent(eventId: Int)
    case characters(eventId: Int)
    case stories(eventId: Int)
    case series(eventId: Int)
    
    var path: String {
        switch self {
        case .allEvents:
            return "/events"
        case .comicsByEvent(let eventId):
            return "/events/\(eventId)/comics"
        case .characters(let eventId):
            return "/events/\(eventId)/characters"
        case .stories(let eventId):
            return "/events/\(eventId)/stories"
        case .series(let eventId):
            return "/events/\(eventId)/series"
        }
    }
}
struct ApiRequestBuilder {
    
    private let baseURL = "https://gateway.marvel.com/v1/public"
    private let apiKey = "bf287d6b190140738cb64f18b89d34de"
    private let privateApiKey = "fee112899260e2fdd3d1bbc60902ea41c9b3baa3"
    private let timeStamp = 1
    private let hash = "4914369d110cda4fc131886d5ee45c47"
    
    
    // Enumeración para los endpoints
    

    func buildRequest(for endpoint: Endpoint, parameters: [String: String] = [:]) -> URLRequest? {
        // Construir la URL base + endpoint
        let urlString = baseURL + endpoint.path
        var components = URLComponents(string: urlString)
        
        
        // Añadir parámetros de consulta
        if !parameters.isEmpty, let key = parameters.keys.first, let value = parameters.values.first {
            let parametersObliged = ["ts" : "\(timeStamp)", "apikey" : apiKey, "hash" : hash, key: value ]
            components?.queryItems = parametersObliged.map { URLQueryItem(name: $0.key, value: $0.value) }
        } else {
            let parametersObliged = ["ts" : "\(timeStamp)", "apikey" : apiKey, "hash" : hash ]
            components?.queryItems = parametersObliged.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else { return nil }
        
        // Crear el objeto URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Cambiar según sea necesario
        
        // Añadir headers
        
        print(request.description)
        return request
    }
}
