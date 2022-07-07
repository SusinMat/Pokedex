//
//  Mocks.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-07-07.
//

import Foundation

class Mocks {
    static var venusaur: Pokemon {
        let id = 3
        return Pokemon(id: id,
                       name: "Venusaur",
                       sprites: Sprites(id: id),
                       poketypeSlots: Mocks.makeTypeSlots("Grass", "Poison"),
                       height: 20,
                       weight: 1000,
                       baseExperience: 263)
    }

    static func makeTypeSlots(_ first: String, _ second: String? = nil) -> [PoketypeSlot] {
        let firstSlot = PoketypeSlot(slot: 0, type: NamedAPIResource(name: first, url: ""))
        if let second = second {
            let secondSlot = PoketypeSlot(slot: 1, type: NamedAPIResource(name: second, url: ""))
            return [firstSlot, secondSlot]
        } else {
            return [firstSlot]
        }
    }

    static var resourceArray: [PokemonResource] {
        return [
            PokemonResource.resource(NamedAPIResource(name: "Foo", url: "https://example.com")),
            PokemonResource.resource(NamedAPIResource(name: "Bar", url: "https://example.com")),
        ]
    }

    static func mock(repository: Repository) async {
        let mockArray = Mocks.resourceArray
        await repository.newPokemonResourceArray(count: mockArray.count + 1)
        await repository.appendPokemonResourceArray(mockArray)
    }
}
