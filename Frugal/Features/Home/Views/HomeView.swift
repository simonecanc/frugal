import SwiftUI

struct HomeView: View {
    @State private var showCameraModal = false
    @State private var isCameraModalMounted = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    // Sfondo sistema (Light Mode)
                    Color.white
                        .ignoresSafeArea(.all)
                    
                    // Contenuto scrollabile
                    ScrollView {
                        VStack(spacing: 20) {
                            Button(action: openCameraModal) {
                                HStack(spacing: 8) {
                                    Image(systemName: "camera.viewfinder")
                                    Text("Apri Camera")
                                }
                                .customFont(.button)
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                            }
                            .buttonStyle(.glassProminent)
                            .controlSize(.large)
                            .tint(.black)
                            .padding(.top, 20)
                            
                            // Spazio per il bottom navigation
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
    
                    if isCameraModalMounted {
                        CameraScannerModalView(isPresented: $showCameraModal)
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
                            .ignoresSafeArea(.container, edges: .bottom)
                            .offset(y: showCameraModal ? 0 : proxy.size.height + 40)
                            .zIndex(1)
                            .animation(.spring(response: 0.34, dampingFraction: 0.9), value: showCameraModal)
                    }
                }
                .onChange(of: showCameraModal) { _, newValue in
                    if newValue {
                        isCameraModalMounted = true
                    } else {
                        Task { @MainActor in
                            try? await Task.sleep(for: .seconds(0.28))
                            if !showCameraModal {
                                isCameraModalMounted = false
                            }
                        }
                    }
                }
                .onAppear {
                    if showCameraModal {
                        isCameraModalMounted = true
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(isCameraModalMounted ? .hidden : .visible, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Frugal")
                        .customStyle(.title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    private func openCameraModal() {
        if !isCameraModalMounted {
            isCameraModalMounted = true
            DispatchQueue.main.async {
                withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                    showCameraModal = true
                }
            }
        } else {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                showCameraModal = true
            }
        }
    }
}

#Preview {
    HomeView()
}
