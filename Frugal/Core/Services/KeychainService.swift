import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let service = "com.canc.tonescroll"
    private let tokenKey = "auth_token"
    private let userKey = "user_data"
    
    private init() {}
    
    // MARK: - Token Management
    
    func saveToken(_ token: String) {
        save(token.data(using: .utf8)!, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        guard let data = load(forKey: tokenKey) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func deleteToken() {
        delete(forKey: tokenKey)
    }
    
    // MARK: - User Data Management
    
    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            save(encoded, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = load(forKey: userKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(User.self, from: data)
    }
    
    func deleteUser() {
        delete(forKey: userKey)
    }
    
    // MARK: - Clear All
    
    func clearAll() {
        deleteToken()
        deleteUser()
    }
    
    // MARK: - Private Keychain Operations
    
    private func save(_ data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Keychain save error: \(status)")
        }
    }
    
    private func load(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else if status != errSecItemNotFound {
            print("Keychain load error: \(status)")
        }
        
        return nil
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete error: \(status)")
        }
    }
}

// MARK: - Secure String Extensions

extension String {
    /// Generates a secure random string
    static func randomSecureString(length: Int = 32) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<letters.count)
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        
        return randomString
    }
}