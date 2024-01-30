import SwiftUI

struct ContentView: View {
    @State private var catInfo: CatInfo?

    var body: some View {
        VStack {
            if let catInfo = catInfo {
                Text("Surprise!")
                    .font(.headline)
                    .padding()
                
                RemoteImageView(url: catInfo.url)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                Text(catInfo.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ProgressView()
                    .padding()
            }
        }
        .onAppear {
            fetchRandomCatInfo()
        }
    }
    func fetchRandomCatInfo() {
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
                print(catData)
                if let firstCat = catData.first {
                    DispatchQueue.main.async {
//                        self.catInfo = CatInfo(name: firstCat.name ?? "Unknown", url: URL(string: firstCat.url))
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
    let name: String?
}

struct CatInfo {
    let name: String
    let url: URL?
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














