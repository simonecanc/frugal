# Setup Instructions

## 🚀 Quick Start

### 1. Clone & Rename
```bash
git clone https://github.com/simonecanc/frugal.git YourAppName
cd YourAppName
```

### 2. Open in Xcode
- Open `Frugal.xcodeproj`
- Select the project in navigator
- Change the Bundle Identifier to your own (e.g., `com.yourcompany.yourapp`)
- Rename the project: Editor → Refactor → Rename

### 3. Install Dependencies

#### Via Swift Package Manager (in Xcode):
1. File → Add Package Dependencies
2. Add: `https://github.com/supabase-community/supabase-swift.git`
3. Add: `https://github.com/google/GoogleSignIn-iOS.git` (optional)

## 🔐 Supabase Setup

### 1. Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Copy your project URL and anon key

### 2. Update Configuration
Edit `App/Config/Environment.swift`:
```swift
var supabaseURL: String {
    return "YOUR_SUPABASE_PROJECT_URL"
}

var supabaseAnonKey: String {
    return "YOUR_SUPABASE_ANON_KEY"
}
```

### 3. Setup Authentication in Supabase
1. Go to Authentication → Providers
2. Enable Email/Password
3. Enable Google (add OAuth credentials)
4. Enable Apple (add Service ID)

## 🍎 Apple Sign-In Setup

### 1. Apple Developer Account
1. Go to developer.apple.com
2. Certificates, Identifiers & Profiles
3. Create App ID with Sign in with Apple capability
4. Create Service ID for web auth

### 2. In Xcode
1. Select project → Signing & Capabilities
2. Add capability: "Sign in with Apple"

## 🔍 Google Sign-In Setup

### 1. Firebase Console
1. Create project at console.firebase.google.com
2. Add iOS app with your Bundle ID
3. Download `GoogleService-Info.plist`
4. Add to Xcode project root

### 2. Update Info.plist
Add URL schemes from `Info.plist.template`

## 🧪 Testing Dev vs Production Mode

### Development Mode (with Skip Login)
```swift
// The app runs in DEBUG mode by default in Xcode
// Skip Login button appears automatically
```

### Production Mode (without Skip Login)
1. **Method 1 - Change Build Configuration:**
   - In Xcode: Product → Scheme → Edit Scheme
   - Run → Info → Build Configuration
   - Change from "Debug" to "Release"
   - Run the app (Cmd+R)

2. **Method 2 - Archive Build:**
   - Product → Archive
   - This always builds in Release mode

3. **Method 3 - Temporary Code Change:**
   ```swift
   // In AuthService.swift, comment out:
   // #if DEBUG
   // @AppStorage("skipLogin") var skipLogin = false
   // #endif
   ```

## 📱 Testing Checklist

### ✅ Auth Flow
- [ ] Apple Sign In works
- [ ] Google Sign In works
- [ ] Email/Password works
- [ ] Sign Out works
- [ ] Token persists after app restart

### ✅ UI Components
- [ ] Tab navigation works
- [ ] Glass buttons have proper effect
- [ ] Dark mode looks good
- [ ] Landscape orientation (if supported)

### ✅ Security
- [ ] Tokens stored in Keychain
- [ ] No sensitive data in logs
- [ ] SSL pinning (if implemented)

## 🚢 Deployment

### TestFlight
1. Product → Archive
2. Distribute App → App Store Connect
3. Upload to TestFlight

### App Store
1. Complete App Store Connect setup
2. Add screenshots
3. Submit for review

## 🆘 Common Issues

### "No such module 'Supabase'"
- File → Add Package Dependencies
- Add Supabase Swift package

### Google Sign-In not working
- Check URL schemes in Info.plist
- Verify GoogleService-Info.plist is added

### Skip Login not showing
- Make sure you're running in Debug mode
- Check AuthService.swift has DEBUG flags

## 📚 Resources

- [Supabase Docs](https://supabase.com/docs)
- [Apple Sign-In](https://developer.apple.com/sign-in-with-apple/)
- [Google Sign-In](https://developers.google.com/identity/sign-in/ios)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
