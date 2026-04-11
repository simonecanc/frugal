import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var showCameraModal = false
    @Published var selectedTab = 0
    
    func openCamera() {
        showCameraModal = true
    }

    func returnToHomeAfterSave() {
        selectedTab = 0
        showCameraModal = false
    }
}
