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
    var typeNames: [String] { (types ?? []).map({ $0.name.capitalized }) }
    var nameLabelUnavailableColor: Color { return Color(white: 0.75) }
    var typeLabelUnavailableColor: Color { return Color(white: 0.85) }

    var body: some View {
        HStack {
            SpriteView(imageURL: imageURL, imageSize: imageSize)
                .environmentObject(repository)
            VStack(alignment: .leading) {
                // name
                switch name {
                case .some(let name):
                    Text(name)
                case .none:
                    EmptyTextLabel(color: nameLabelUnavailableColor)
                }

                // type(s)
                switch typeNames.isEmpty {
                case true:
                    EmptyTextLabel(color: typeLabelUnavailableColor)
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
}
