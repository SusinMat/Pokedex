//
//  Repository.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import UIKit

actor Repository: RepositoryProtocol {
    var currentPokemonPage: Int = 0

    lazy var service: ServiceProtocol = Service.shared

    func setService(_ service: ServiceProtocol) {
        self.service = service
    }

    nonisolated func fetchImage(url: String) async throws -> Data {
        return try await service.fetchImage(url: url)
    }

    nonisolated func fetchCurrentPage() async throws -> NamedAPIResourceList {
        let page = try await service.fetchPage(pageNumber: currentPokemonPage)
        return page
    }

    nonisolated func fetchPokemon(at url: String) async throws -> Pokemon {
        let pokemon = try await service.fetchPokemon(at: url)
        return pokemon
    }
}

// MARK: - Image Cache Helper
class ImageCacheHelper {
    static func retrieveOrFetchImage(url: String, viewModel: ViewModel) async -> UIImage? {
        do {
            if let image = await viewModel.images[url] {
                return image
            }
            let data = try await viewModel.repository.fetchImage(url: url)
            let uiImage = UIImage(data: data)
            let trimmedUIImage = uiImage?.trimmingTransparentPixels()
            if let trimmedUIImage = trimmedUIImage {
                await viewModel.updateImage(url: url, image: trimmedUIImage)
                return trimmedUIImage
            } else if let uiImage = uiImage {
                print("Error in \(#function): Unable to trim an instance of UIImage.")
                await viewModel.updateImage(url: url, image: uiImage)
                return uiImage
            }
            return nil
        } catch (let error) {
            print("Error in \(#function): \(error)")
            return nil
        }
    }
}

// MARK: - Convenience Init
extension Repository {
    init(service: ServiceProtocol) async {
        self.init()
        self.setService(service)
    }
}
