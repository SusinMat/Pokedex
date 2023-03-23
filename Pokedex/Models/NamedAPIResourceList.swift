//
//  NamedAPIResourceList.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

struct NamedAPIResourceList: Codable, Equatable, Hashable {
    let count: Int
    let previous: String?
    let next: String?
    let results: [NamedAPIResource]
}
