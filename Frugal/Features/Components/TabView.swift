import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        SwiftUI.TabView(selection: $appState.selectedTab) {
            Tab("Search", systemImage: "house.fill", value: 0) {
                HomeView()
            }

            Tab("Saved", systemImage: "bookmark.fill", value: 1) {
                SavedView()
            }

            // ✅ "+" a destra — ora apre la camera
            Tab(value: 99, role: .search) {
                Color.clear
            } label: {
                Image(systemName: "plus")
            }
        }
        .preferredColorScheme(.light)
        .tint(.black)
        .onChange(of: appState.selectedTab) { oldTab, newValue in
            if newValue == 99 {
                appState.selectedTab = oldTab
                appState.openCamera()
            }
        }
        .sheet(isPresented: $appState.showCameraModal) {
            CameraScannerModalView(isPresented: $appState.showCameraModal)
                .presentationSizing(.page)
                .presentationCompactAdaptation(.sheet)
                .presentationCornerRadius(26)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
