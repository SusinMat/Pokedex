//
//  ServiceProtocol.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-31.
//

import Foundation

protocol ServiceProtocol {
    func fetchPage(pageNumber: Int) async throws -> NamedAPIResourceList
    func fetchPokemon(at url: String) async throws -> Pokemon
    func fetchImage(url: String) async throws -> Data
}
