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

    var id: Int {
        switch self {
        case .none(let id):
            return id
        case .resource(let resource):
            return resource.url.hashValue
        case .pokemon(let pokemon):
            return pokemon.name.hashValue
        }
    }

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
    let height: Int?
    let weight: Int?
    let baseExperience: Int?

    var types: [NamedAPIResource] {
        poketypeSlots.sorted(by: { $0.slot < $1.slot }).map({ $0.`type` })
    }

    var typeNames: [String] {
        return types.map({ $0.name.capitalized })
    }

    var hasOwnEntry: Bool {
        return id <= 10_000
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case poketypeSlots = "types"
        case height
        case weight
        case baseExperience
    }
}

// MARK: - Sprites
struct Sprites: Codable, Equatable, Hashable {
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
}

extension Sprites {
    init(id: Int) {
        func makeSpriteURL(sprite: Services.SpriteRoute) -> String{
            return Services.makeSpriteURL(id: id, sprite: sprite)
        }
        let sprites = Sprites(frontDefault: makeSpriteURL(sprite: .frontDefault),
                              frontFemale: makeSpriteURL(sprite: .frontFemale),
                              frontShiny: makeSpriteURL(sprite: .frontShiny),
                              frontShinyFemale: makeSpriteURL(sprite: .frontShinyFemale))
        self = sprites
    }
}

// MARK: - Poketype Slots
struct PoketypeSlot: Codable, Equatable, Hashable {
    let slot: Int
    let `type`: NamedAPIResource
}

// MARK: - Decoder
class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
