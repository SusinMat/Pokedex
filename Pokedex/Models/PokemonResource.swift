//
//  PokemonResource.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
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
