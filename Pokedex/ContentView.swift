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
    let title = "Pokédex"

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
                let name = pokemon.name.capitalized
                NavigationLink(destination: PokemonInfoView(pokemon: pokemon).environmentObject(repository)) {
                    PokemonCell(name: name,
                                types: pokemon.types,
                                imageURL: pokemon.sprites.frontDefault)
                    .environmentObject(repository)
                }
            default:
                PokemonCell()
            }
        }
        .environmentObject(repository)
        .navigationTitle(title)
        .onAppear {
            Task.detached {
                if await repository.pokemonResources.isEmpty {
                    await repository.startFetchingPages()
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView().preferredColorScheme(.light)
        PreviewView().preferredColorScheme(.dark)
    }

    struct PreviewView: View {
        @StateObject var repository: Repository

        init() {
            self._repository = StateObject(wrappedValue: Repository()) // sets the default value
        }

        var body: some View {
            NavigationView {
                ContentView(repository: repository)
            }
        }
    }
}
