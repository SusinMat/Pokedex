//
//  PoketypeSlot.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

struct PoketypeSlot: Codable, Equatable, Hashable {
    let slot: Int
    let `type`: NamedAPIResource
}
