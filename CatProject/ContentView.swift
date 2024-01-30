//
//  ContentView.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import SwiftUI

struct ContentView: View {
    @State private var catImageURL: URL?

    var body: some View {
        VStack {
            if let imageURL = catImageURL {
                RemoteImageView(url: imageURL)
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                ProgressView()
                    .padding()
            }
        }
        .onAppear {
            fetchRandomCatImage()
        }
    }
    
    func fetchRandomCatImage() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned from API")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let catData = try decoder.decode([Cat].self, from: data)
                if let firstCat = catData.first, let catURL = URL(string: firstCat.url) {
                    DispatchQueue.main.async {
                        self.catImageURL = catURL
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Cat: Decodable {
    let url: String
}

struct RemoteImageView: View {
    private var url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        if let url = url {
            RemoteImage(url: url)
        } else {
            Image(systemName: "questionmark")
                .foregroundColor(.gray)
        }
    }
}

struct RemoteImage: View {
    private var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        if let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "questionmark")
                .foregroundColor(.gray)
        }
    }
}
