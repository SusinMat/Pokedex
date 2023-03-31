//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-03-23.
//

import SwiftUI


@main
struct PokedexApp: App {
    init() {
        print("App init() is running!")
        if PokedexApp.isInDebugMode {
            Task {
                await PokedexApp.printFirstPage()
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(.stack) // should allow .columns on iPad, but this is causing constraint errors...
        }
    }
}

// MARK: - Debug Functions
extension PokedexApp {
    static var isInDebugMode: Bool { return false }
    static var throttlingRequestsIsRequired: Bool { return false }
}

extension PokedexApp {
    static func printFirstPage() async {
        do {
            let firstPage = try await Service.shared.fetchPage(pageNumber: 1)
            print(firstPage)
        } catch(let error) {
            print("Error in \(#function): \(error)")
        }
    }
}
