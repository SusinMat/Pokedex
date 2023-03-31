//
//  Sprites.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import Foundation

struct Sprites: Codable, Equatable, Hashable {
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
}

extension Sprites {
    init(id: Int) {
        func makeSpriteURL(sprite: Service.SpriteRoute) -> String {
            return Service.makeSpriteURL(id: id, sprite: sprite)
        }
        let sprites = Sprites(frontDefault: makeSpriteURL(sprite: .frontDefault),
                              frontFemale: makeSpriteURL(sprite: .frontFemale),
                              frontShiny: makeSpriteURL(sprite: .frontShiny),
                              frontShinyFemale: makeSpriteURL(sprite: .frontShinyFemale))
        self = sprites
    }
}
