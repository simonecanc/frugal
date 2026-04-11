import AVFoundation
import Combine
import SwiftUI
import UIKit

struct CameraScannerModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var appState: AppState
    @StateObject private var cameraManager = CameraSessionManager()
    @State private var isScanning = false
    @State private var scanningResetTask: Task<Void, Never>?
    @State private var previewBootstrapTask: Task<Void, Never>?
    @State private var isPreviewVisible = false
    @State private var capturedImage: UIImage?
    @State private var showResult = false

    var body: some View {
        ZStack {
            // Camera layer
            if !showResult {
                ZStack {
                    Color.black
                        .ignoresSafeArea()

                    if isPreviewVisible {
                        CameraPreviewView(session: cameraManager.session)
                            .transition(.opacity)
                            .ignoresSafeArea()
                    }

                    ScannerGuideView(isScanning: isScanning)
                        .ignoresSafeArea()

                    _ScannerTopChrome(
                        isScanning: isScanning,
                        onClose: closeModal
                    )

                    VStack(spacing: 0) {
                        Spacer()

                        Button(action: captureAndStartScanning) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 82, height: 82)

                                Circle()
                                    .stroke(.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .disabled(isScanning)
                        .padding(.bottom, 30)
                    }
                }
                .transition(.opacity)
            }

            // Result layer
            if showResult, let image = capturedImage {
                ScanResultView(
                    capturedImage: image,
                    onDismiss: dismissResult,
                    onSave: closeModalAfterSave
                )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .background(.black)
        .onAppear {
            previewBootstrapTask?.cancel()
            isPreviewVisible = false

            cameraManager.start()

            previewBootstrapTask = Task {
                try? await Task.sleep(for: .seconds(0.46))
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.18)) {
                        isPreviewVisible = true
                    }
                }
            }
        }
        .onDisappear {
            previewBootstrapTask?.cancel()
            scanningResetTask?.cancel()
            isScanning = false
            isPreviewVisible = false
            showResult = false
            capturedImage = nil
            cameraManager.stop()
        }
    }

    private func closeModal() {
        isPresented = false
    }

    private func closeModalAfterSave() {
        appState.returnToHomeAfterSave()
    }

    private func captureAndStartScanning() {
        guard !isScanning else { return }

        // Capture a real photo
        cameraManager.capturePhoto { image in
            guard let image else { return }
            self.capturedImage = image
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            isScanning = true
        }

        scanningResetTask?.cancel()
        scanningResetTask = Task {
            try? await Task.sleep(for: .seconds(2.4))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.2)) {
                    isScanning = false
                }
                // Navigate to result after scanning completes
                if capturedImage != nil {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.88)) {
                        showResult = true
                    }
                }
            }
        }
    }

    private func dismissResult() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
            showResult = false
        }
        // Restart camera
        capturedImage = nil
        cameraManager.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.18)) {
                isPreviewVisible = true
            }
        }
    }
}

private struct _ScannerTopChrome: View {
    let isScanning: Bool
    let onClose: () -> Void

    var body: some View {
        GeometryReader { proxy in
            let topPadding = proxy.safeAreaInsets.top + 20
            let chromeHeight: CGFloat = 34
            let guideWidth = min(proxy.size.width * 0.88, 360)
            let guideHeight = guideWidth * 1.12
            let guideTop = (proxy.size.height - guideHeight) / 2
            let headerBottom = topPadding + chromeHeight
            let badgeCenterY = headerBottom + ((guideTop - headerBottom) / 2)

            ZStack(alignment: .top) {
                ZStack {
                    Text("Frugal")
                        .customStyle(.title1)
                        .adaptiveGlassForeground()

                    HStack {
                        Spacer()

                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .semibold))
                                .adaptiveGlassForeground()
                                .frame(width: 34, height: 34)
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .controlSize(.small)
                    }
                }
                .frame(height: chromeHeight)
                .padding(.top, topPadding)
                .padding(.horizontal, 16)

                if isScanning {
                    ScanningStatusBadgeView()
                        .position(x: proxy.size.width / 2, y: badgeCenterY)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea(edges: .top)
    }
}

private struct ScannerGuideView: View {
    let isScanning: Bool
    @State private var animateScanLine = false

    var body: some View {
        GeometryReader { proxy in
            let width = min(proxy.size.width * 0.88, 360)
            let height = width * 1.12
            let scanTravel = max(0, height - 78)

            ZStack {
                RoundedCornerGuideShape(cornerLength: 70, cornerRadius: 26)
                    .stroke(
                        .white,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: width, height: height)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)

                if isScanning {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.black.opacity(0.08))
                        .frame(width: width - 22, height: height - 22)

                    Rectangle()
                        .fill(
                            .linearGradient(
                                colors: [.clear, .white.opacity(0.95), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width - 52, height: 4)
                        .offset(y: animateScanLine ? scanTravel / 2 : -scanTravel / 2)
                        .shadow(color: .white.opacity(0.55), radius: 10, x: 0, y: 0)

                }
            }
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .onChange(of: isScanning) { _, newValue in
            if newValue {
                animateScanLine = false
                withAnimation(.linear(duration: 1.05).repeatForever(autoreverses: true)) {
                    animateScanLine = true
                }
            } else {
                animateScanLine = false
            }
        }
    }
}

private struct ScanningStatusBadgeView: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                ProgressView()
                    .tint(.white)
                Text("Scanning")
                    .customStyle(.caption)
            }
            .adaptiveGlassForeground()
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.capsule)
        .allowsHitTesting(false)
    }
}

private extension View {
    func adaptiveGlassForeground() -> some View {
        self
            .foregroundStyle(.white)
            .blendMode(.difference)
    }
}

private struct RoundedCornerGuideShape: Shape {
    let cornerLength: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = min(cornerLength, min(rect.width, rect.height) * 0.35)
        let radius = min(cornerRadius, length * 0.7)
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        path.move(to: CGPoint(x: minX, y: minY + length))
        path.addLine(to: CGPoint(x: minX, y: minY + radius))
        path.addArc(
            center: CGPoint(x: minX + radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: minX + length, y: minY))

        path.move(to: CGPoint(x: maxX - length, y: minY))
        path.addLine(to: CGPoint(x: maxX - radius, y: minY))
        path.addArc(
            center: CGPoint(x: maxX - radius, y: minY + radius),
            radius: radius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: maxX, y: minY + length))

        path.move(to: CGPoint(x: maxX, y: maxY - length))
        path.addLine(to: CGPoint(x: maxX, y: maxY - radius))
        path.addArc(
            center: CGPoint(x: maxX - radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: maxX - length, y: maxY))

        path.move(to: CGPoint(x: minX + length, y: maxY))
        path.addLine(to: CGPoint(x: minX + radius, y: maxY))
        path.addArc(
            center: CGPoint(x: minX + radius, y: maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: minX, y: maxY - length))

        return path
    }
}

private struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.session = session
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.videoPreviewLayer.session = session
    }
}

private final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

private final class CameraSessionManager: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.frugal.camera.session")
    private let photoOutput = AVCapturePhotoOutput()
    private var didConfigureSession = false
    private var photoCaptureCompletion: ((UIImage?) -> Void)?

    func start() {
        let authorization = AVCaptureDevice.authorizationStatus(for: .video)

        switch authorization {
        case .authorized:
            configureAndStart()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                self?.configureAndStart()
            }
        default:
            break
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCaptureCompletion = completion

        sessionQueue.async { [weak self] in
            guard let self else { return }
            let settings = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }

        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

    private func configureAndStart() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            if !self.didConfigureSession {
                self.configureSession()
            }

            if self.didConfigureSession && !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        defer {
            session.commitConfiguration()
        }

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            return
        }

        session.addInput(input)

        // Add photo output for actual capture
        guard session.canAddOutput(photoOutput) else { return }
        session.addOutput(photoOutput)
        photoOutput.maxPhotoQualityPrioritization = .balanced

        didConfigureSession = true
    }

    private func finishPhotoCapture(with image: UIImage?) {
        if image != nil {
            stop()
        }

        photoCaptureCompletion?(image)
        photoCaptureCompletion = nil
    }
}

extension CameraSessionManager: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        let imageData = error == nil ? photo.fileDataRepresentation() : nil

        Task { @MainActor [weak self] in
            guard let self else { return }
            let image = imageData.flatMap(UIImage.init(data:))
            self.finishPhotoCapture(with: image)
        }
    }
}
