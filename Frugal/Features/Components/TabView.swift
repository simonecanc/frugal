import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            SwiftUI.TabView(selection: $selectedTab) {
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
            .onChange(of: selectedTab) { oldTab, newValue in
                if newValue == 99 {
                    selectedTab = oldTab
                    appState.openCamera() // 👈 stessa funzione del vecchio Scan
                }
            }
            .toolbar(appState.isCameraModalMounted ? .hidden : .visible, for: .tabBar)

            // Camera Modal
            if appState.isCameraModalMounted {
                GeometryReader { proxy in
                    let cameraTopInset = max(0, proxy.safeAreaInsets.top - 12)
                    CameraScannerModalView(isPresented: $appState.showCameraModal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 26,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 26
                            ),
                            style: FillStyle(antialiased: false)
                        )
                        .padding(.top, cameraTopInset)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .offset(y: appState.showCameraModal ? 0 : proxy.size.height)
                        .zIndex(10)
                        .animation(.spring(response: 0.34, dampingFraction: 0.9), value: appState.showCameraModal)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
