import SwiftUI

struct PhotoListView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var selectedPhoto: Photo?
    @State private var isFullScreen = false
    @State private var dragOffset = CGSize.zero
    @State private var searchText = ""
    @State private var wishlist: [Photo] = [] 

    var filteredPhotos: [Photo] {
        if searchText.isEmpty {
            return viewModel.photos
        } else {
            return viewModel.photos.filter { photo in
                photo.description?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Search by description", text: $searchText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                List(filteredPhotos) { photo in
                    VStack(alignment: .leading) {
                        ZStack(alignment: .topTrailing) {
                            
                            AsyncImage(url: URL(string: photo.urls.small)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(maxHeight: isFullScreen && selectedPhoto?.id == photo.id ? .infinity : 200)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    if selectedPhoto?.id == photo.id {
                                        isFullScreen.toggle()
                                    } else {
                                        selectedPhoto = photo
                                        isFullScreen = true
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(isFullScreen && selectedPhoto?.id == photo.id ? 0 : 10)

                            Button(action: {
                                
                                if let index = wishlist.firstIndex(where: { $0.id == photo.id }) {
                                    wishlist.remove(at: index)
                                } else {
                                    wishlist.append(photo)
                                }
                            }) {
                                Image(systemName: wishlist.contains(where: { $0.id == photo.id }) ? "heart.fill" : "heart")
                                    .foregroundColor(wishlist.contains(where: { $0.id == photo.id }) ? .red : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                                    .padding()
                            }
                        }

                        if isFullScreen && selectedPhoto?.id == photo.id {
                            VStack {
                                Spacer()

                                Text(photo.description ?? "No Description")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                                    .offset(dragOffset)
                                    .gesture(DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation
                                        }
                                        .onEnded { _ in
                                            dragOffset = .zero
                                        }
                                    )

                                Text("By: \(photo.user.name)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)

                                Text("👍: \(photo.likes)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(8)
                                Spacer()
                            }
                            .padding()
                            .transition(.opacity)
                        }
                    }
                    .padding()
                    .background(
                        isFullScreen && selectedPhoto?.id == photo.id ? Color.black.opacity(0.8) : Color.clear
                    )
                }
                .onAppear {
                    viewModel.fetchPhotos()
                }
            }
            .navigationTitle("Photos")
            .toolbar {
              
                NavigationLink(destination: WishlistView(wishlist: $wishlist)) {
                    Text("Wishlist")
                }
            }
        }
    }
}

struct WishlistView: View {
    @Binding var wishlist: [Photo] 
    var body: some View {
        VStack {
            if wishlist.isEmpty {
                Text("Your wishlist is empty!")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List(wishlist) { photo in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: photo.urls.small)) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxHeight: 200)
                        .cornerRadius(10)

                        Text(photo.description ?? "No Description")
                            .font(.headline)
                            .padding(.top)

                        Text("By: \(photo.user.name)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Wishlist")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView()
    }
}

