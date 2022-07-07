//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-07-06.
//

import SwiftUI

struct PokemonInfoView: View {
    var pokemon: Pokemon
    var name: String {
        return pokemon.name.capitalized
    }
    var title: String {
        if pokemon.hasOwnEntry {
            return "#\(pokemon.id): \(name)"
        } else {
            return name
        }
    }

    @EnvironmentObject var repository: Repository

    let imageSize = 180.0
    let tabViewPadding = 25.0

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    var body: some View {
        VStack {
            ScrollView {
                tabView.center()
                type.center()
                VStack {
                    PropertyCell(Measurement.height, pokemon.height)
                    Divider()
                    PropertyCell(Measurement.weight, pokemon.weight)
                    Divider()
                    PropertyCell("Base Experience", pokemon.baseExperience)
                }
                .padding([.vertical], 5.0)
                .padding([.horizontal], 10.0)
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                .cornerRadius(15.0)
                .padding([.horizontal], 10.0)
            }
        }
        .navigationTitle(title)
    }

    var tabView: some View {
        TabView {
            sprite(imageURL: pokemon.sprites.frontDefault)
            sprite(imageURL: pokemon.sprites.frontShiny)
        }
        .frame(width: UIScreen.main.bounds.width, height: imageSize + tabViewPadding)
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.5)
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
        }
    }

    var type: some View {
        Text(pokemon.typeNames.joined(separator: " / "))
            .font(.system(size: 36.0))
            .foregroundColor(.gray)
            .topPadding(-tabViewPadding)
    }

    func sprite(imageURL: String?) -> some View {
        SpriteView(imageURL: imageURL, imageSize: imageSize)
            .environmentObject(repository)
            .bottomPadding(tabViewPadding)
    }

    enum Measurement: String {
        case height = "Height"
        case weight = "Weight"

        var unit: String {
            switch self {
            case .height:
                return "m"
            case .weight:
                return "kg"
            }
        }
    }
}

// MARK: - Property Cell
extension PokemonInfoView {
    struct PropertyCell: View {
        @State var title: String
        @State var value: String

        static let unknownPropertyString = "???"

        init(_ title: String, _ value: String?) {
            self.title = title
            self.value = value ?? Self.unknownPropertyString
        }

        init(_ title: String, _ value: Int?) {
            self.title = title
            if let value = value {
                self.value = String(value)
            } else {
                self.value = Self.unknownPropertyString
            }
        }

        init(_ unit: Measurement, _ value: Int?) {
            self.title = unit.rawValue
            if let value = value {
                self.value = Self.formatFixedPointValue(value) + " \(unit.unit)"
            } else {
                self.value = Self.unknownPropertyString
            }
        }

        var body: some View {
            HStack {
                Text(title).foregroundColor(Color(uiColor: UIColor.label))
                Spacer()
                Text(value).foregroundColor(Color(uiColor: UIColor.secondaryLabel))
            }
            .frame(minWidth: 0.0, idealWidth: nil, maxWidth: UIScreen.main.bounds.width,
                   minHeight: 32.0, idealHeight: nil, maxHeight: nil,
                   alignment: .center)
        }

        static func formatFixedPointValue(_ value: Int) -> String {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            let floatingValueFromFixedPointValue = Double(value) / 10.0
            return formatter.string(from: floatingValueFromFixedPointValue as NSNumber)!
        }
    }
}


struct PokemonInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let testPokemon = Mocks.venusaur
        NavigationView {
            PokemonInfoView(pokemon: testPokemon)
        }
    }
}
