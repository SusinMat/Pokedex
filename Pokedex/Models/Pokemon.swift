//
//  Pokemon.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

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
