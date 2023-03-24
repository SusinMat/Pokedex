//
//  Repository.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2023-03-23.
//

import UIKit

actor Repository {
    var currentPokemonPage: Int = 0

    lazy var service = Services.shared

    func resetPageCount() {
        currentPokemonPage = 0
    }

    func incrementPageCount() {
        currentPokemonPage += 1
    }

    func fetchImage(url: String) async throws -> Data {
        guard let url = URL(string: url) else {
            print("Error in \(#function): Unable to convert \(url) to URL.")
            throw ServiceError.stringIsNotValidURL
        }
        return try await service.fetchImage(url: url)
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
