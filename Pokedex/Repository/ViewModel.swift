//
//  ViewModel.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-24.
//

import Foundation
import UIKit


@MainActor class ViewModel: ObservableObject {
    @Published var pokemonResources: [PokemonResource] = []
    @Published var images: [String: UIImage] = [:]

    lazy var repository: RepositoryProtocol = Repository()

    // MARK: - Self-writing functions
    func flushPokemonResourceArray() async {
        pokemonResources = []
        await repository.resetPageCount()
    }

    func newPokemonResourceArray(count: Int) async {
        pokemonResources = (1...count).map({ PokemonResource.none($0) })
        await repository.resetPageCount()
    }

    func appendPokemonResourceArray(_ new: [PokemonResource]) async {
        pokemonResources.append(contentsOf: new)
        await repository.incrementPageCount()
    }

    func setRepository(_ repository: RepositoryProtocol) {
        self.repository = repository
    }

    nonisolated func trimAndUpdateImage(url: String, imageData: Data) async {
        if let uiImage = UIImage(data: imageData) {
            let trimmedImage = uiImage.trimmingTransparentPixels() ?? uiImage
            await updateImage(url: url, image: trimmedImage)
        }
    }

    func updateImage(url: String, image: UIImage) {
        images[url] = image
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

    func updatePokemonArrayWithResources(_ new: [PokemonResource]) async {
        if new.isEmpty {
            return
        }
        guard let insertionPosition = pokemonResources.firstIndex(where: { $0.isNone }) else {
            print("Error: Attempt to fill complete array.")
            return
        }
        let range = insertionPosition..<insertionPosition + new.count
        pokemonResources.replaceSubrange(range, with: new)
        await repository.incrementPageCount()
    }

    // MARK: - Fetch functions
    func startFetchingPages() async {
        await repository.resetPageCount()
        await fetchNextPage()
    }

    nonisolated func fetchNextPage() async {
        do {
            let page = try await repository.fetchCurrentPage()
            if page.previous == nil {
                await newPokemonResourceArray(count: page.count)
            }
            await updatePokemonArrayWithResources(page.results.map({ PokemonResource.resource($0) }))
            if page.next != nil {
                Task.detached {
                    if PokedexApp.throttlingRequestsIsRequired {
                        await Wait.waitFor(seconds: 0.500)
                    }
                    await self.fetchNextPage()
                }
            }

            Task.detached { [weak self] in
                await self?.fetchPokemonInPage(page: page)
            }
        } catch (let error) {
            print("Error in \(#function): \(error)")
        }
    }

    nonisolated func fetchPokemonInPage(page: NamedAPIResourceList) async {
        let urlToPokemon = await withTaskGroup(of: (String, Pokemon)?.self,
                                               returning: [String: Pokemon].self) { taskGroup in
            for resource in page.results {
                taskGroup.addTask { [weak self] in
                    do {
                        guard let pokemon = try await self?.repository.fetchPokemon(at: resource.url) else {
                            return nil
                        }
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

    nonisolated func retrieveOrFetchImage(url: String) async -> UIImage? {
        do {
            if let image = await images[url] {
                return image
            }
            let data = try await repository.fetchImage(url: url)
            await trimAndUpdateImage(url: url, imageData: data)
            return await images[url]
        } catch (let error) {
            print("Error in \(#function): \(error)")
            return nil
        }
    }
}

// MARK: - Convenience Init
extension ViewModel {
    convenience init(repository: RepositoryProtocol) async {
        self.init()
        self.setRepository(repository)
    }
}
