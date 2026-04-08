import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Sfondo sistema (Light Mode)
                Color(UIColor.systemBackground)
                    .ignoresSafeArea(.all)
                
                // Contenuto scrollabile
                ScrollView {
                    VStack(spacing: 20) {
                        // Content placeholder for future sections
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 200)
                            .overlay(
                                Text("Content coming soon")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.customCaption)
                            )
                        
                        // Spazio per il bottom navigation
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Frugal")
                        .font(.customTitleRegular)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
