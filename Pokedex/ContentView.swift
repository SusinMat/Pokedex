//
//  ContentView.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import SwiftUI


// MARK: - ContentView
struct ContentView: View {
    @State var pokemon: [PokemonResource] = []
    @StateObject var repository: Repository = Repository()

    var body: some View {
        List(repository.pokemonResources, id: \.self) { item in // TODO: add internalID based on Index
            switch item {
            case .resource(let resource):
                Cell(name: resource.name.capitalized)
            case .pokemon(let pokemon):
                Cell(name: pokemon.name.capitalized, types: pokemon.getTypes(), imageURL: pokemon.sprites.frontDefault)
            default:
                Cell()
            }
        }
        .environmentObject(repository)
        .onAppear {
            Task {
                repository.startFetchingPages()
            }
        }
    }
}

// MARK: - Cell
struct Cell: View {
    var name: String?
    var types: [NamedAPIResource]?
    var imageURL: String?

    let imageSize = 40.0
    var image: Image = Image(systemName: "photo")
    var typeNames: [String] { (types ?? []).map({ $0.name.capitalized }) }
    let veryLightGray = Color(white: 0.8)
    let evenLighterGray = Color(white: 0.9)

    var body: some View {
        HStack{
            image.fixedSize().frame(width: imageSize, height: imageSize, alignment: .center)
            VStack(alignment: .leading) {
                // name
                switch name {
                case .some(let name):
                    Text(name)
                case .none:
                    Text(String(repeating: " ", count: 32)).background(veryLightGray)
                }

                // type(s)
                switch typeNames.isEmpty {
                case true:
                    Text(String(repeating: " ", count: 32)).background(evenLighterGray)
                case false:
                    Text(typeNames.joined(separator: " / "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            if name == nil || types == nil {
                Spacer()
                ProgressView().progressViewStyle(.circular).padding(.trailing, 8.0)
            }
        }
        .padding([.vertical], 2.0)
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Repository())
    }
}
