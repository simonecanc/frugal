import SwiftUI

struct LoginView: View {
    @State private var animateGradient = false
    @AppStorage("didLogin") private var didLogin = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and Title
                    headerSection
                    
                    // Primary action
                    Button(action: { didLogin = true }) {
                        HStack(spacing: 8) {
                            Text("Get Started")
                                .customStyle(.button)

                            Image(systemName: "arrow.right")
                        }
                        .customFont(.button)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.blue)
                    .controlSize(.large)
                }
                .padding(.vertical, 60)
                .padding(.horizontal)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Animated Logo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.cyan.opacity(0.3),
                                Color.blue.opacity(0.3)
                            ],
                            startPoint: animateGradient ? .topLeading : .bottomTrailing,
                            endPoint: animateGradient ? .bottomTrailing : .topLeading
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 10)
                
                Image(systemName: "drop.fill")
                    .font(.customLogoSymbol)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient = true
                }
            }
            
            VStack(spacing: 8) {
                Text("Welcome")
                    .customStyle(.largeTitle)
                    .foregroundStyle(.primary)
                
                Text("Tap to get started")
                    .customStyle(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    LoginView()
}
