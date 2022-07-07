//
//  SwiftUIExtensions.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-07-07.
//

import SwiftUI

extension View {
    func center() -> some View {
        self.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }

    func topPadding(_ value: CGFloat) -> some View {
        self.padding(EdgeInsets(top: value, leading: 0.0, bottom: 0.0, trailing: 0.0))
    }

    func bottomPadding(_ value: CGFloat) -> some View {
        self.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: value, trailing: 0.0))
    }
}
