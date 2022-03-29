//
//  Models.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import Foundation

enum PokemonResource: Equatable, Hashable {
    case none(Int)
    case resource(NamedAPIResource)
    case pokemon(Pokemon)

    var asResource: NamedAPIResource? {
        if case .resource(let resource) = self {
            return resource
        }
        return nil
    }

    var asPokemon: Pokemon? {
        if case .pokemon(let pokemon) = self {
            return pokemon
        }
        return nil
    }

    var isNone: Bool {
        if case PokemonResource.none = self {
            return true
        }
        return false
    }
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
    let poketypeSlots: [PoketypeSlot]

    func getTypes() -> [NamedAPIResource] {
        poketypeSlots.sorted(by: { $0.slot < $1.slot }).map({ $0.typeResource })
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case poketypeSlots = "types"
    }
}

// MARK: - Sprites
struct Sprites: Codable, Equatable, Hashable {
    let frontDefault: String?
    let frontShiny: String?
}

// MARK: - Poketype Slots
struct PoketypeSlot: Codable, Equatable, Hashable {
    let slot: Int
    let typeResource: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case slot
        case typeResource = "type"
    }
}

// MARK: - Decoder
class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
