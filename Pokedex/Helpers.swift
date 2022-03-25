//
//  Helpers.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-25.
//

import Foundation

class Wait {
    static func waitFor(seconds: TimeInterval) async {
        try? await Task<Never, Never>.sleep(nanoseconds: UInt64(1_000_000_000 * seconds))
    }
}
