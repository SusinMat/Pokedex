//
//  ContentView.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import SwiftUI


// MARK: - ContentView
struct ContentView: View {
    @StateObject var viewModel: ViewModel
    let title = "Pokédex"

    init() {
        self._viewModel = StateObject(wrappedValue: ViewModel()) // sets the default value
    }

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List(viewModel.pokemonResources, id: \.id) { item in
            switch item {
            case .resource(let resource):
                PokemonCell(name: resource.name.capitalized)
            case .pokemon(let pokemon):
                let name = pokemon.name.capitalized
                NavigationLink(destination: PokemonInfoView(pokemon: pokemon).environmentObject(viewModel)) {
                    PokemonCell(name: name,
                                types: pokemon.types,
                                imageURL: pokemon.sprites.frontDefault)
                    .environmentObject(viewModel)
                }
            default:
                PokemonCell()
            }
        }
        .environmentObject(viewModel)
        .navigationTitle(title)
        .onAppear {
            Task.detached {
                if await viewModel.pokemonResources.isEmpty {
                    await viewModel.startFetchingPages()
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
        @StateObject var viewModel: ViewModel

        init() {
            self._viewModel = StateObject(wrappedValue: ViewModel()) // sets the default value
        }

        var body: some View {
            NavigationView {
                ContentView(viewModel: viewModel)
            }
        }
    }
}
