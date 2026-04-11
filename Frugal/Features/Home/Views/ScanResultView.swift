import SwiftUI

struct ScanResultView: View {
    let capturedImage: UIImage
    let onDismiss: () -> Void
    let onSave: () -> Void

    @State private var showContent = false
    @State private var showScanned = false
    @State private var showAlternatives = false
    @State private var cutoutImage: UIImage?
    @State private var isProcessingCutout = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: – Scanned image
                    ZStack {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 280)
                            .clipped()
                            .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 28,
                                    bottomTrailingRadius: 28,
                                    topTrailingRadius: 0
                                )
                            )
                            .overlay(
                                LinearGradient(
                                    colors: [.black.opacity(0.5), .black.opacity(0.1), .black.opacity(0.35)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 0,
                                        bottomLeadingRadius: 28,
                                        bottomTrailingRadius: 28,
                                        topTrailingRadius: 0
                                    )
                                )
                            )
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                    // MARK: – Your scanned product card
                    _ScannedProductCard()
                        .padding(.horizontal, 16)
                        .padding(.top, -30)
                        .opacity(showScanned ? 1 : 0)
                        .offset(y: showScanned ? 0 : 20)

                    // MARK: – Alternatives header
                    HStack {
                        Text("We found better options")
                            .customStyle(.title3)
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 22)
                    .padding(.bottom, 12)
                    .opacity(showAlternatives ? 1 : 0)

                    // MARK: – Two alternative cards
                    HStack(alignment: .center, spacing: 10) {
                        _AlternativeCard(
                            tagLabel: "Cheaper",
                            tagIcon: "arrow.down.circle.fill",
                            tagColor: .green,
                            productName: "Egg Whites Liquid",
                            brand: "Store Brand",
                            price: "1.89",
                            originalPrice: "2.47",
                            pricePerUnit: "$0.21/100g",
                            savingsPercent: "24%",
                            rating: 4.1,
                            reviewCount: "1.2k",
                            badgeText: "Lowest price",
                            badgeColor: .green,
                            glassTint: .green.opacity(0.72),
                            usesDarkContent: false
                        )
                        .opacity(showAlternatives ? 1 : 0)
                        .offset(x: showAlternatives ? 0 : -30)

                        _AlternativeCard(
                            tagLabel: "Frugal Choice",
                            tagIcon: "leaf.fill",
                            tagColor: .white.opacity(0.9),
                            productName: "Cage-Free Egg Whites",
                            brand: "Kirkland Signature",
                            price: "3.49",
                            originalPrice: nil,
                            pricePerUnit: "$0.26/100g",
                            savingsPercent: nil,
                            rating: 4.8,
                            reviewCount: "3.4k",
                            badgeText: "Best long-term",
                            badgeColor: .white.opacity(0.9),
                            glassTint: .black.opacity(0.82),
                            usesDarkContent: true
                        )
                        .opacity(showAlternatives ? 1 : 0)
                        .offset(x: showAlternatives ? 0 : 30)
                    }
                    .padding(.horizontal, 12)

                    // MARK: – Why Frugal explanation
                    _WhyFrugalCard()
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .opacity(showAlternatives ? 1 : 0)

                    Spacer(minLength: 120)
                }
            }
            .ignoresSafeArea(.container, edges: .top)

            // MARK: – Floating top buttons
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .adaptiveTopChromeForeground()
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .controlSize(.small)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .adaptiveTopChromeForeground()
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .controlSize(.small)
            }
            .padding(.top, 56)
            .padding(.horizontal, 16)

            // MARK: – Bottom CTA
            VStack {
                Spacer()

                Button(action: saveAndDismiss) {
                    HStack(spacing: 8) {
                        if isProcessingCutout {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        Text("Save to Home")
                    }
                    .customFont(.button)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                }
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .tint(.black)
                .disabled(isProcessingCutout)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 0.45).delay(0.2)) {
                showScanned = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82).delay(0.4)) {
                showAlternatives = true
            }
            // Start background removal immediately
            startBackgroundRemoval()
        }
    }

    // MARK: – Background Removal & Save

    private func startBackgroundRemoval() {
        Task {
            let result = await BackgroundRemovalService.shared.removeBackground(from: capturedImage)
            await MainActor.run {
                cutoutImage = result
            }
        }
    }

    private func saveAndDismiss() {
        // If cutout is already ready, save immediately
        if let cutout = cutoutImage {
            ProductImageStore.shared.saveProduct(
                cutoutImage: cutout,
                productName: "Liquid Egg Whites",
                price: "$2.47"
            )
            onSave()
        } else {
            // Cutout still processing – wait for it
            isProcessingCutout = true
            Task {
                let result = await BackgroundRemovalService.shared.removeBackground(from: capturedImage)
                await MainActor.run {
                    if let result {
                        ProductImageStore.shared.saveProduct(
                            cutoutImage: result,
                            productName: "Liquid Egg Whites",
                            price: "$2.47"
                        )
                    } else {
                        // Fallback: save original image if removal fails
                        ProductImageStore.shared.saveProduct(
                            cutoutImage: capturedImage,
                            productName: "Liquid Egg Whites",
                            price: "$2.47"
                        )
                    }
                    isProcessingCutout = false
                    onSave()
                }
            }
        }
    }
}

// MARK: – Scanned Product Card

private struct _ScannedProductCard: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Liquid Egg Whites")
                .customStyle(.title1)
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)

            Text("$2.47")
                .customStyle(.title2)
                .foregroundStyle(.white.opacity(0.9))
                .monospacedDigit()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .glassEffect(
            .regular.tint(.black.opacity(0.82)),
            in: .rect(cornerRadius: 20)
        )
        .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 4)
        .environment(\.colorScheme, .dark)
    }
}

// MARK: – Alternative Product Card

private struct _AlternativeCard: View {
    let tagLabel: String
    let tagIcon: String
    let tagColor: Color
    let productName: String
    let brand: String
    let price: String
    let originalPrice: String?
    let pricePerUnit: String
    let savingsPercent: String?
    let rating: Double
    let reviewCount: String
    let badgeText: String
    let badgeColor: Color
    let glassTint: Color
    let usesDarkContent: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            _OptionGlassPill(
                title: tagLabel,
                icon: tagIcon,
                usesDarkContent: usesDarkContent
            )

            _AlternativeProductMockImage(usesDarkContent: usesDarkContent)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
                .padding(.bottom, 4)

            Text(productName)
                .customStyle(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(primaryText)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("$\(price)")
                    .customStyle(.title2)
                    .monospacedDigit()
                    .foregroundStyle(primaryText)

                if let originalPrice, !usesDarkContent {
                    Text("$\(originalPrice)")
                        .customStyle(.footnote)
                        .foregroundStyle(secondaryText)
                        .strikethrough(color: secondaryText.opacity(0.7))
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(
            .regular.tint(glassTint),
            in: .rect(cornerRadius: 20)
        )
        .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 4)
        .environment(\.colorScheme, usesDarkContent ? .dark : .light)
    }

    private var primaryText: Color {
        usesDarkContent ? .white : .black
    }

    private var secondaryText: Color {
        usesDarkContent ? .white.opacity(0.68) : .black.opacity(0.55)
    }
}

// MARK: – Why Frugal Explanation Card

private struct _WhyFrugalCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Why Frugal recommends this")
                .customStyle(.headline)
                .foregroundStyle(.primary)

            HStack(alignment: .center, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Good value")
                        .font(.system(size: 32, weight: .semibold, design: .default))
                        .foregroundStyle(.primary)

                    Text("About $1 more, but a better long-term buy.")
                        .customStyle(.subheadline)
                        .foregroundStyle(Color.black.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                _WhyFrugalScoreGauge(score: 8.3)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 6)
    }
}

private struct _ResultCardTag: View {
    let title: String
    let icon: String
    let tint: Color
    let usesDarkContent: Bool

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))

            Text(title)
                .customStyle(.label)
        }
        .foregroundStyle(usesDarkContent ? .white.opacity(0.92) : tint)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(usesDarkContent ? Color.white.opacity(0.12) : tint.opacity(0.12))
        )
    }
}

private struct _OptionGlassPill: View {
    let title: String
    let icon: String
    let usesDarkContent: Bool

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(foreground)

            Text(title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .tracking(-0.3)
                .foregroundStyle(foreground)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private var foreground: Color {
        usesDarkContent ? .white.opacity(0.95) : .black.opacity(0.82)
    }
}

private struct _AlternativeProductMockImage: View {
    let usesDarkContent: Bool

    var body: some View {
        ZStack {
            if usesDarkContent {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.16),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 38, height: 72)
                    .overlay(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white.opacity(0.16))
                            .frame(width: 18, height: 14)
                            .offset(x: 8, y: 8)
                    }
                    .rotationEffect(.degrees(-8))
                    .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 5)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color.white.opacity(0.72)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 34, height: 62)

                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.white.opacity(0.75))
                        .frame(width: 22, height: 6)
                        .offset(y: -20)
                }
                .rotationEffect(.degrees(10))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
            }
        }
        .frame(height: 76)
    }
}

private struct _WhyFrugalScoreGauge: View {
    let score: Double

    private var progress: Double {
        score / 10
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.12, to: 0.88)
                .stroke(Color.black.opacity(0.10), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(90))

            Circle()
                .trim(from: 0.12, to: 0.12 + (0.76 * progress))
                .stroke(_whyFrugalGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(90))

            VStack(spacing: 2) {
                Text(String(format: "%.1f", score))
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundStyle(_whyFrugalGreen)

                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(_whyFrugalGreen)
            }
        }
        .frame(width: 96, height: 96)
    }
}

private let _whyFrugalGreen = Color(red: 0.54, green: 0.86, blue: 0.56)

private struct _ResultStatBlock: View {
    let value: String
    let label: String
    let usesDarkContent: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .customStyle(.headline)
                .foregroundStyle(usesDarkContent ? .white : .black)
                .monospacedDigit()
                .lineLimit(1)

            Text(label)
                .customStyle(.label)
                .foregroundStyle(usesDarkContent ? .white.opacity(0.62) : .black.opacity(0.45))
                .lineLimit(1)
        }
    }
}

private extension View {
    func adaptiveTopChromeForeground() -> some View {
        self
            .foregroundStyle(.white)
            .blendMode(.difference)
    }
}

private struct _ReasonRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .padding(.top, 1)

            Text(text)
                .customStyle(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    ScanResultView(
        capturedImage: .scanResultPreviewSample,
        onDismiss: {},
        onSave: {}
    )
}

private extension UIImage {
    static var scanResultPreviewSample: UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 900, height: 1200))

        return renderer.image { context in
            let cg = context.cgContext
            let colors = [
                UIColor(red: 0.96, green: 0.91, blue: 0.80, alpha: 1).cgColor,
                UIColor(red: 0.69, green: 0.55, blue: 0.40, alpha: 1).cgColor,
                UIColor(red: 0.17, green: 0.16, blue: 0.20, alpha: 1).cgColor
            ] as CFArray

            let locations: [CGFloat] = [0.0, 0.34, 1.0]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)

            if let gradient {
                cg.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: 0, y: 1200),
                    options: []
                )
            }

            cg.setFillColor(UIColor.white.withAlphaComponent(0.25).cgColor)
            cg.fill(CGRect(x: 80, y: 120, width: 740, height: 140))

            cg.setFillColor(UIColor.black.withAlphaComponent(0.18).cgColor)
            cg.fill(CGRect(x: 0, y: 260, width: 900, height: 220))

            cg.setStrokeColor(UIColor.white.withAlphaComponent(0.22).cgColor)
            cg.setLineWidth(14)
            cg.strokeEllipse(in: CGRect(x: 250, y: 520, width: 380, height: 380))
        }
    }
}
