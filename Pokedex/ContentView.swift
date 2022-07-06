//
//  ContentView.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import SwiftUI


// MARK: - ContentView
struct ContentView: View {
    @StateObject var repository: Repository

    init() {
        self._repository = StateObject(wrappedValue: Repository()) // sets the default value
    }

    init(repository: Repository) {
        self._repository = StateObject(wrappedValue: repository)
    }

    var body: some View {
        List(repository.pokemonResources, id: \.id) { item in
            switch item {
            case .resource(let resource):
                PokemonCell(name: resource.name.capitalized)
            case .pokemon(let pokemon):
                PokemonCell(name: pokemon.name.capitalized,
                            types: pokemon.getTypes(),
                            imageURL: pokemon.sprites.frontDefault)
                    .environmentObject(repository)
            default:
                PokemonCell()
            }
        }
        .environmentObject(repository)
        .onAppear {
            Task {
                await repository.startFetchingPages()
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    @StateObject static var repository: Repository = Repository()

    static var previews: some View {
        ContentView.init(repository: repository)
            .onAppear {
                repository.mockData()
            }
    }
}

extension Repository {
    func mockData() {
        self.newPokemonResourceArray(count: 3)
        self.appendPokemonResourceArray([
            PokemonResource.resource(NamedAPIResource(name: "Foo", url: "https://example.com")),
            PokemonResource.resource(NamedAPIResource(name: "Bar", url: "https://example.com"))
        ])
    }
}
