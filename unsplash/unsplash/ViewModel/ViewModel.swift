import Foundation
import Combine

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var filteredPhotos: [Photo] = []
    private var cancellables = Set<AnyCancellable>()

    func fetchPhotos() {
        guard let url = URL(string: "https://api.unsplash.com/photos?client_id=nECQKaZFgQAxe9rtqjftDnx3-V--REoP5PtZui31oOw") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching photos: \(error)")
                }
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
            })
            .store(in: &cancellables)
    }
    func filterPhotos(by query: String) {
        if query.isEmpty {
            filteredPhotos = photos
        } else {
            filteredPhotos = photos.filter { photo in
                photo.description?.localizedCaseInsensitiveContains(query) == true ||
                photo.user.name.localizedCaseInsensitiveContains(query)
            }
        }
    }
}

