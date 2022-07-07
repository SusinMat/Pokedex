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
        HStack {
            SpriteView(image: imageToBeDisplayed, imageSize: imageSize)
            VStack(alignment: .leading) {
                // name
                switch name {
                case .some(let name):
                    Text(name)
                case .none:
                    EmptyTextLabel(color: veryLightGray)
                }

                // type(s)
                switch typeNames.isEmpty {
                case true:
                    EmptyTextLabel(color: evenLighterGray)
                case false:
                    TypeLabel(typeNames: typeNames)
                }
            }
            if name == nil || types == nil {
                Spacer()
                ProgressView().progressViewStyle(.circular).padding(.trailing, 8.0)
            }
        }
        .padding([.vertical], 2.0)
        .onAppear(perform: {
            Task.detached {
                await retrieveImage()
            }
        })
    }

    struct EmptyTextLabel: View {
        var color: Color
        var body: some View {
            Text(String(repeating: " ", count: 32)).background(color)
        }
    }

    struct TypeLabel: View {
        var typeNames: [String]
        var body: some View {
            Text(typeNames.joined(separator: " / "))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    struct SpriteView: View {
        var image: UIImage
        var imageSize: CGFloat
        var body: some View {
            Image(uiImage: image)
                .resizable().aspectRatio(contentMode: .fit).frame(width: imageSize, height: imageSize)
        }
    }

    func retrieveImage() async {
        guard let imageURL = imageURL else {
            return
        }
        let image = await ImageCacheHelper.retrieveOrFetchImage(url: imageURL, repository: repository)
        storedImage = image
    }
}
