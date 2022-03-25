//
//  Repository.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-24.
//

import Foundation

@MainActor class Repository: ObservableObject {
    var currentPokemonPage: Int = 0
    @Published var pokemonResources: [PokemonResource] = []

    func flushPokemonResourceArray() {
        pokemonResources = []
        currentPokemonPage = 0
    }

    func newPokemonResourceArray(count: Int) {
        pokemonResources = Array(repeating: .none, count: count)
        currentPokemonPage = 0
    }

    func appendPokemonResourceArray(_ new: [PokemonResource]) {
        pokemonResources.append(contentsOf: new)
        currentPokemonPage += 1
    }

    func updatePokemonArrayWithResources(_ new: [PokemonResource]) {
        if new.isEmpty {
            return
        }
        guard let insertionPosition = pokemonResources.firstIndex(where: { $0 == PokemonResource.none }) else {
            print("Error: Attempt to fill complete array.")
            return
        }
        let range = insertionPosition..<insertionPosition + new.count
        pokemonResources.replaceSubrange(range, with: new)
        currentPokemonPage += 1
    }

    func startFetchingPages() {
        Task {
            currentPokemonPage = 0
            await fetchNextPage()
        }
    }

    func fetchNextPage() async {
        do {
            let page = try await Services.shared.fetchPage(pageNumber: currentPokemonPage)
            if page.previous == nil {
                newPokemonResourceArray(count: page.count)
            }
            updatePokemonArrayWithResources(page.results.map({ PokemonResource.resource($0) }))
            if page.next != nil {
                Task {
                    await Wait.waitFor(seconds: 0.500)
                    await self.fetchNextPage()
                }
            }
        } catch (let error) {
            print("Error in \(#function): \(error)")
        }
    }
}
