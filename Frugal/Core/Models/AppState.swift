import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var showCameraModal = false {
        didSet {
            if !showCameraModal {
                // When closing, wait for animation then unmount
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    if !self.showCameraModal {
                        self.isCameraModalMounted = false
                    }
                }
            } else {
                isCameraModalMounted = true
            }
        }
    }
    @Published var isCameraModalMounted = false
    @Published var cameraPresentationResetKey = UUID()
    
    func openCamera() {
        cameraPresentationResetKey = UUID()

        if !isCameraModalMounted {
            isCameraModalMounted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                    self.showCameraModal = true
                }
            }
        } else {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.9)) {
                self.showCameraModal = true
            }
        }
    }
}
