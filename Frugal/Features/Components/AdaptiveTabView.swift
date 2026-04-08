import SwiftUI

struct AdaptiveTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "sun.horizon.circle.fill")
                    Text("Today")
                }
            
            PastView()
                .tabItem {
                    Image(systemName: "cloud.bolt.rain.circle.fill")
                    Text("Past")
                }
        }
        .preferredColorScheme(.light)
        .tint(.blue)
    }
}

#Preview {
    AdaptiveTabView()
}
