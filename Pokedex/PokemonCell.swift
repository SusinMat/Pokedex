//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-04-04.
//

import SwiftUI


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
