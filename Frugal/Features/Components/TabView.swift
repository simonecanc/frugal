import SwiftUI

struct TabView: View {
    var body: some View {
        SwiftUI.TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "sun.horizon.circle.fill")
                    Text("Today")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "cloud.bolt.rain.circle.fill")
                    Text("History")
                }
        }
        .preferredColorScheme(.light)
        .tint(.black)
    }
}

#Preview {
    TabView()
}
