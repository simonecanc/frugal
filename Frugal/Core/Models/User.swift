import Foundation

enum AuthProvider: String, Codable {
    case email = "email"
    case google = "google"
    case apple = "apple"
}

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String?
    let provider: AuthProvider
    let avatarURL: String?
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: String,
        email: String,
        name: String? = nil,
        provider: AuthProvider = .email,
        avatarURL: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.provider = provider
        self.avatarURL = avatarURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Mock Data
extension User {
    static var mockUser: User {
        User(
            id: "mock-user-id",
            email: "developer@test.com",
            name: "Test Developer",
            provider: .email,
            avatarURL: nil
        )
    }
    
    static var mockUsers: [User] {
        [
            User(
                id: "1",
                email: "john@example.com",
                name: "John Doe",
                provider: .google
            ),
            User(
                id: "2",
                email: "jane@example.com",
                name: "Jane Smith",
                provider: .apple
            ),
            User(
                id: "3",
                email: "bob@example.com",
                name: "Bob Johnson",
                provider: .email
            )
        ]
    }
}