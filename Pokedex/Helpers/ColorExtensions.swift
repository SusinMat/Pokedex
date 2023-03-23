//
//  ColorExtensions.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-08-08.
//

import SwiftUI

extension Color {
    static func whiteInvertedForDarkMode(_ white: CGFloat) -> Color {
//        @Environment(\.colorScheme) var colorScheme: ColorScheme // this doesn't work because Color is not a View and has no Environment
        let colorScheme = UITraitCollection.current.userInterfaceStyle
        switch colorScheme {
        case .light:
            return Color(white: white)
        case .dark:
            return Color(white: 1.0 - white)
        default:
            NSLog("Error in \(#function): Unhandled Color Scheme selected: \(colorScheme.rawValue).")
            return Color(white: white)
        }
    }
}
