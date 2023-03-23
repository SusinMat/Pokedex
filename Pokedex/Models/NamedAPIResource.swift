//
//  NamedAPIResource.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

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
