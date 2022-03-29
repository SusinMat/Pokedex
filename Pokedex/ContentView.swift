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
        List(repository.pokemonResources, id: \.self) { item in
            switch item {
            case .resource(let resource):
                PokemonCell(name: resource.name.capitalized)
            case .pokemon(let pokemon):
                PokemonCell(name: pokemon.name.capitalized, types: pokemon.getTypes(), imageURL: pokemon.sprites.frontDefault)
                    .environmentObject(repository)
            default:
                PokemonCell()
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

// MARK: - Pokemon Cell
struct PokemonCell: View {
    var name: String?
    var types: [NamedAPIResource]?
    var imageURL: String?

    @EnvironmentObject var repository: Repository

    let imageSize = 60.0
    @State var storedImage: UIImage?
    var typeNames: [String] { (types ?? []).map({ $0.name.capitalized }) }
    let veryLightGray = Color(white: 0.8)
    let evenLighterGray = Color(white: 0.9)
    static let defaultImage = UIImage(systemName: "photo")!

    var imageToBeDisplayed: UIImage {
        return storedImage ?? PokemonCell.defaultImage
    }

    var body: some View {
        HStack{
            Image(uiImage: imageToBeDisplayed)
                .resizable().aspectRatio(contentMode: .fit).frame(width: imageSize, height: imageSize)
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
        .onAppear(perform: {
            Task {
                await retrieveImage()
            }
        })
    }

    func retrieveImage() async {
        guard let imageURL = imageURL else {
            return
        }
        storedImage = await repository.retrieveOrFetchImage(url: imageURL)
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Repository())
    }
}
