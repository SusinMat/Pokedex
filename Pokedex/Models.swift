//
//  Models.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import Foundation

enum PokemonResource: Equatable, Hashable {
    case none
    case resource(NamedAPIResource)
    case pokemon(Pokemon)
}

// MARK: - NamedAPIResourceList
struct NamedAPIResourceList: Codable, Equatable, Hashable {
    let count: Int
    let previous: String?
    let next: String?
    let results: [NamedAPIResource]
}

// MARK: - NamedAPIResource
struct NamedAPIResource: Codable, Equatable, Hashable {
    let name: String
    let url: String

    func getStringID() -> String {
        return NSString(string: url).lastPathComponent
    }

    func getNumericID() -> Int? {
        return Int(getStringID())
    }
}

// MARK: - Pokemon
struct Pokemon: Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let sprites: Sprites
    let poketypes: [NamedAPIResource]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case poketypes = "types"
    }
}

// MARK: - Sprites
struct Sprites: Codable, Equatable, Hashable {
    let frontDefault: String
    let frontShiny: String
}

// MARK: - Poketypes
struct Poketype: Codable, Equatable, Hashable {
    // intentionally left blank (for now)
}

// MARK: - Decoder
class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
