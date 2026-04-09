import SwiftUI

@main
struct FrugalApp: App {
    @State private var showSplash = true
    @AppStorage("didLogin") private var didLogin = false
    
    init() {
        setupAppearance()
        setupEnvironment()
    }
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity.combined(with: .scale))
                } else {
                    if didLogin {
                        TabView()
                    } else {
                        LoginView()
                    }
                }
            }
            .environmentObject(appState)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSplash)
            .preferredColorScheme(.light)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
    
    private func setupAppearance() {
        // Liquid Glass appearance setup
        #if os(iOS)
        if #available(iOS 18.0, *) {
            // Enable Liquid Glass features when available
            UINavigationBar.appearance().prefersLargeTitles = true
        }
        #endif
    }
    
    private func setupEnvironment() {
        #if DEBUG
        // Reduce console noise in debug builds
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        UserDefaults.standard.set(false, forKey: "CAMetalLayerDrawableDidComputeThrottleInterval")
        #endif
    }
}

struct SplashView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "drop.fill")
                    .font(.customHeroSymbol)
                    .foregroundStyle(.linearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .scaleEffect(animate ? 1.0 : 0.8)
                    .opacity(animate ? 1.0 : 0.7)
                
                Text("Frugal")
                    .customStyle(.largeTitle)
                    .foregroundStyle(.primary)
                    .opacity(animate ? 1.0 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
