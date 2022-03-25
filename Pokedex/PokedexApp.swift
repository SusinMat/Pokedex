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
        if isInDebugMode {
            Task {
                await PokedexApp.printFirstPage()
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Debug Functions
extension App {
    var isInDebugMode: Bool { return false }
}

extension PokedexApp {
    static func printFirstPage() async {
        do {
            let firstPage = try await Services.shared.fetchPage(pageNumber: 1)
            print(firstPage)
        } catch(let error) {
            print("Error in \(#function): \(error)")
        }
    }
}
