import SwiftUI

struct TabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            SwiftUI.TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Search")
                    }
                    .tag(0)
                
                // Placeholder for Scan tab
                Color.clear
                    .tabItem {
                        Image(systemName: "viewfinder.circle.fill")
                        Text("Scan")
                    }
                    .tag(1)
                
                SavedView()
                    .tabItem {
                        Image(systemName: "bookmark.fill")
                        Text("Saved")
                    }
                    .tag(2)
            }
            .preferredColorScheme(.light)
            .tint(.black)
            .onChange(of: selectedTab) { oldTab, newValue in
                if newValue == 1 {
                    selectedTab = oldTab 
                    appState.openCamera()
                }
            }
            .toolbar(appState.isCameraModalMounted ? .hidden : .visible, for: .tabBar)

            // Global Camera Modal
            // We put it in a ZStack so it can be on top of TabView but under NavBars if possible
            // Actually, ZStack at this level is on top of EVERYTHING.
            // To see the NavBar, we must not cover it.
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
    TabView()
        .environmentObject(AppState())
}
