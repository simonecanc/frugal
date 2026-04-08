import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://dev.api.example.com"
        case .staging:
            return "https://staging.api.example.com"
        case .production:
            return "https://api.example.com"
        }
    }
    
    var supabaseURL: String {
        switch self {
        case .development, .staging:
            return "YOUR_DEV_SUPABASE_URL"
        case .production:
            return "YOUR_PROD_SUPABASE_URL"
        }
    }
    
    var supabaseAnonKey: String {
        switch self {
        case .development, .staging:
            return "YOUR_DEV_SUPABASE_ANON_KEY"
        case .production:
            return "YOUR_PROD_SUPABASE_ANON_KEY"
        }
    }
    
    var googleClientId: String {
        switch self {
        case .development, .staging:
            return "YOUR_DEV_GOOGLE_CLIENT_ID"
        case .production:
            return "YOUR_PROD_GOOGLE_CLIENT_ID"
        }
    }
    
    var isDebugMode: Bool {
        return self == .development
    }
    
    var shouldShowLogs: Bool {
        return self != .production
    }
}

// MARK: - App Configuration

struct AppConfig {
    static let shared = AppConfig()
    
    let environment = Environment.current
    let appName = "Frugal"
    let bundleId = "com.canc.frugal"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "hasLaunchedBefore")
        }
    }
    
    private init() {}
}
