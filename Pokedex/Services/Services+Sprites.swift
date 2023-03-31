//
//  Service+Sprites.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

// MARK: - Sprites
extension Service {
    static let baseSpriteURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    enum SpriteRoute: String {
        case frontDefault = ""
        case frontFemale = "female/"
        case frontShiny = "shiny/"
        case frontShinyFemale = "shiny/female/"
    }

    static func makeSpriteURL(id: Int, sprite: SpriteRoute) -> String {
        return Service.baseSpriteURL + sprite.rawValue + String(id)
    }
}
