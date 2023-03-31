//
//  RepositoryProtocol.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-31.
//

import Foundation

protocol RepositoryProtocol: Actor {
    var currentPokemonPage: Int { get set }

    func resetPageCount()
    func incrementPageCount()

    nonisolated func fetchImage(url: String) async throws -> Data

    nonisolated func fetchCurrentPage() async throws -> NamedAPIResourceList

    nonisolated func fetchPokemon(at url: String) async throws -> Pokemon
}

// MARK: - Default Implementations
extension RepositoryProtocol {
    func resetPageCount() {
        currentPokemonPage = 0
    }

    func incrementPageCount() {
        currentPokemonPage += 1
    }
}
