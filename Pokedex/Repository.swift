//
//  Repository.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-24.
//

import Foundation
import UIKit


@MainActor class Repository: ObservableObject {
    var currentPokemonPage: Int = 0
    @Published var pokemonResources: [PokemonResource] = []
    @Published var images: [String: UIImage] = [:]

    func flushPokemonResourceArray() {
        pokemonResources = []
        currentPokemonPage = 0
    }

    func newPokemonResourceArray(count: Int) {
        pokemonResources = (1...count).map({ PokemonResource.none($0) })
        currentPokemonPage = 0
    }

    func appendPokemonResourceArray(_ new: [PokemonResource]) {
        pokemonResources.append(contentsOf: new)
        currentPokemonPage += 1
    }

    func updateImage(url: String, imageData: Data) {
        if let uiImage = UIImage(data: imageData) {
            images[url] = uiImage.trimmingTransparentPixels() ?? uiImage
        }
    }

    func replaceResourceWithPokemon(url: String, pokemon: Pokemon) {
        guard let resourceIndex = pokemonResources.firstIndex(where: { $0.asResource?.url == url }) else {
            print("Error in \(#function): Could not locate Pokemon Resource with URL == \(url).")
            return
        }
        pokemonResources[resourceIndex] = .pokemon(pokemon)
    }

    func replaceResourcesWithPokemon(urlToPokemon: [String: Pokemon]) {
        for (url, pokemon) in urlToPokemon {
            guard let resourceIndex = pokemonResources.firstIndex(where: { $0.asResource?.url == url }) else {
                print("Error in \(#function): Could not locate Pokemon Resource with URL == \(url).")
                return
            }
            pokemonResources[resourceIndex] = .pokemon(pokemon)
        }
    }

    func updatePokemonArrayWithResources(_ new: [PokemonResource]) {
        if new.isEmpty {
            return
        }
        guard let insertionPosition = pokemonResources.firstIndex(where: { $0.isNone }) else {
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

            Task.detached(priority: .medium) {
                let urlToPokemon = await withTaskGroup(of: (String, Pokemon)?.self,
                                                       returning: [String: Pokemon].self) { taskGroup in
                    for resource in page.results {
                        taskGroup.addTask {
                            do {
                                let pokemon = try await Services.shared.fetchPokemon(at: resource.url)
                                return (resource.url, pokemon)
                            } catch (let error) {
                                print("Error: Unable to obtain Pokemon due to \(error).")
                            }
                            return nil
                        }
                    }
                    var urlToPokemon: [String: Pokemon] = [:]
                    for await result in taskGroup.compactMap({ $0 }) {
                        urlToPokemon[result.0] = result.1
                    }
                    return urlToPokemon
                }
                await self.replaceResourcesWithPokemon(urlToPokemon: urlToPokemon)
            }
        } catch (let error) {
            print("Error in \(#function): \(error)")
        }
    }

    func retrieveOrFetchImage(url: String) async -> UIImage? {
        do {
            if let image = images[url] {
                return image
            }
            let data = try await Services.shared.fetchImage(url: url)
            updateImage(url: url, imageData: data)
            return images[url]
        } catch (let error) {
            print("Error in \(#function): \(error)")
            return nil
        }
    }
}
