//
//  AsyncImageView.swift
//  Pokedex
//
//  Created by Dylan MIFTARI on 2/17/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var imageData: Data?
    
    var body: some View {
        Group {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    private func loadImage() {
            guard let url = URL(string: url) else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageData = data
                    }
                }
            }.resume()
        }
}
