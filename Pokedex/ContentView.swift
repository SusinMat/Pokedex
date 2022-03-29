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

    let imageSize = 40.0
    @State var imageData: Data?
    var typeNames: [String] { (types ?? []).map({ $0.name.capitalized }) }
    let veryLightGray = Color(white: 0.8)
    let evenLighterGray = Color(white: 0.9)

    var uiImage: UIImage {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return UIImage(systemName: "photo") ?? UIImage()
    }

    var body: some View {
        HStack{
            Image(uiImage: uiImage).frame(width: imageSize, height: imageSize, alignment: .center).scaledToFit()
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
        let imageData = await repository.retrieveOrFetchImage(url: imageURL)
        self.imageData = imageData
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Repository())
    }
}
