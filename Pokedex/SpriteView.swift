//
//  SpriteView.swift
//  Pokedex
//
//  Created by Matheus Martins Susin on 2022-07-07.
//

import SwiftUI

struct SpriteView: View {
    var imageURL: String?
    var imageSize: CGFloat
    @EnvironmentObject var repository: Repository
    @State var storedImage: UIImage?
    static let defaultImage = UIImage(systemName: "photo")!

    var imageToBeDisplayed: UIImage {
        return storedImage ?? Self.defaultImage
    }

    var body: some View {
        Image(uiImage: imageToBeDisplayed)
            .resizable().aspectRatio(contentMode: .fit).frame(width: imageSize, height: imageSize)
            .onAppear(perform: {
                Task.detached {
                    await retrieveImageIfNeeded()
                }
            })
    }

    func retrieveImageIfNeeded() async {
        if storedImage != nil {
            return
        }
        guard let imageURL = imageURL else {
            return
        }
        await retrieveImage(url: imageURL)
    }

    func retrieveImage(url: String) async {
        let image = await ImageCacheHelper.retrieveOrFetchImage(url: url, repository: repository)
        storedImage = image
    }
}
