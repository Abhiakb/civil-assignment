struct Photo: Codable, Identifiable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: User
    let urls: PhotoURLs
    let links: PhotoLinks

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
        case links
    }
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case portfolioURL = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct PhotoLinks: Codable {
    let selfLink: String
    let html: String
    let download: String
    let downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case download
        case downloadLocation = "download_location"
    }
}

