import SwiftUI

struct ContentView: View {
    @State private var breeds: [Breed] = []
    @State private var selectedBreed: Breed?
    @State private var selectedBreedImageURL: String?

    var body: some View {
        VStack {
            Button(action: {
                selectedBreed = breeds.randomElement()
                if let breed = selectedBreed {
                    fetchCatImage(breedId: breed.id)
                }
            }) {
                Text("Generate a Random Cat")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue).opacity(01
)
                    .cornerRadius(10)
                    .padding()
            }

            if let imageURL = selectedBreedImageURL {
                VStack {
                    Spacer()
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "exclamationmark.icloud")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 400, height: 400)
                    .cornerRadius(10)
                    .padding()

                    Text(selectedBreed?.name ?? "Unknown")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.blue)
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            fetchCatBreeds()
        }
    }

    func fetchCatBreeds() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data returned from API")
                return
            }

            do {
                let decoder = JSONDecoder()
                breeds = try decoder.decode([Breed].self, from: data)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    func fetchCatImage(breedId: String) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(breedId)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data returned from API")
                return
            }

            do {
                let decoder = JSONDecoder()
                let catImages = try decoder.decode([CatImage].self, from: data)
                if let firstImage = catImages.first {
                    selectedBreedImageURL = firstImage.url
                } else {
                    print("No image found for selected breed")
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Breed: Decodable, Identifiable, Hashable {
    let id: String
    let name: String?
}

struct CatImage: Decodable, Identifiable {
    let id: String
    let url: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

