//
//  Services.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import Foundation
import SwiftUI

class Services {
    static let baseURL = "https://pokeapi.co/api/v2"
    var session: URLSession { return URLSession.shared }
    static let decoder = SnakeCaseJSONDecoder()

    var pokemonPageSize = 25

    static let shared: Services = {
        let instance = Services()
        return instance
    }()

    static func makeURLString(_ route: String) -> URL {
        let urlString = "\(Services.baseURL)\(route)"
        guard let url = URL(string: urlString) else {
            preconditionFailure("\(#function) failed to produce valid URL from \(urlString)")
        }
        return url
    }

    func fetchPage(pageNumber: Int) async throws -> NamedAPIResourceList {
        let route = "pokemon"
        let limit = "limit=\(pokemonPageSize)"
        let offset = "offset=\(pageNumber * pokemonPageSize)"
        let url = Services.makeURLString("/\(route)?\(limit)&\(offset)")
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request, delegate: nil)
        return try Services.decoder.decode(NamedAPIResourceList.self, from: data)
    }

    func fetchPokemon(at url: String) async throws -> Pokemon {
        guard let url = URL(string: url) else {
            print("Error in \(#function): Unable to convert \(url) to URL.")
            throw ServiceError.stringIsNotValidURL
        }
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request, delegate: nil)
        let decodedPokemon = try Services.decoder.decode(Pokemon.self, from: data)
        return decodedPokemon
    }
}

enum ServiceError: Error {
    case stringIsNotValidURL
}
