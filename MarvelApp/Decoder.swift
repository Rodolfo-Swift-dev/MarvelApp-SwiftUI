//
//  Decoder.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import Foundation

struct Decoder {
    // Definimos una constante jsonDecoder utilizando una closure para configurar el decodificador
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder() // Crea una instancia de JSONDecoder para decodificar datos JSON.
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Configura el decodificador para convertir claves en snake_case a camelCase, lo cual es común cuando los datos provienen de un API en JSON.
        return decoder // Devuelve el decodificador configurado.
    }()
}
