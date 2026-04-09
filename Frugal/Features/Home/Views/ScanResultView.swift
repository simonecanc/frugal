import SwiftUI

struct ScanResultView: View {
    let capturedImage: UIImage
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var showScanned = false
    @State private var showAlternatives = false

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
                    HStack(alignment: .top, spacing: 10) {
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
                            badgeColor: .green
                        )
                        .opacity(showAlternatives ? 1 : 0)
                        .offset(x: showAlternatives ? 0 : -30)

                        _AlternativeCard(
                            tagLabel: "Frugal Choice",
                            tagIcon: "leaf.fill",
                            tagColor: .blue,
                            productName: "Cage-Free Egg Whites",
                            brand: "Kirkland Signature",
                            price: "3.49",
                            originalPrice: nil,
                            pricePerUnit: "$0.26/100g",
                            savingsPercent: nil,
                            rating: 4.8,
                            reviewCount: "3.4k",
                            badgeText: "Best long-term",
                            badgeColor: .blue
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
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .controlSize(.small)
                .tint(.white)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .controlSize(.small)
                .tint(.white)
            }
            .padding(.top, 56)
            .padding(.horizontal, 16)

            // MARK: – Bottom CTA
            VStack {
                Spacer()

                Button(action: onDismiss) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Choose Frugal Option")
                    }
                    .customFont(.button)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                }
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .tint(.black)
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
        }
    }
}

// MARK: – Scanned Product Card

private struct _ScannedProductCard: View {
    var body: some View {
        HStack(spacing: 14) {
            // Product icon
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                Image(systemName: "basket.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Your product")
                    .customStyle(.label)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text("Liquid Egg Whites")
                    .customStyle(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text("Great Value · 907g")
                    .customStyle(.footnote)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // Your current price
            VStack(alignment: .trailing, spacing: 0) {
                Text("$2.47")
                    .customStyle(.title2)
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                Text("$0.27/100g")
                    .customStyle(.label)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 4)
        )
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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tag
            HStack(spacing: 4) {
                Image(systemName: tagIcon)
                    .font(.system(size: 10, weight: .bold))
                Text(tagLabel)
                    .customStyle(.label)
                    .textCase(.uppercase)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(tagColor.gradient, in: Capsule())

            // Brand
            Text(brand)
                .customStyle(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .padding(.top, 10)

            // Product name
            Text(productName)
                .customStyle(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)

            // Price block
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text("$")
                        .customStyle(.headline)
                    Text(price)
                        .customStyle(.title1)
                        .monospacedDigit()
                }
                .foregroundStyle(.primary)

                if let originalPrice {
                    Text("$\(originalPrice)")
                        .customStyle(.callout)
                        .foregroundStyle(.tertiary)
                        .strikethrough(color: .gray)
                }
            }
            .padding(.top, 10)

            // Price per unit
            Text(pricePerUnit)
                .customStyle(.label)
                .foregroundStyle(.secondary)
                .padding(.top, 1)

            // Savings badge (if applicable)
            if let savingsPercent {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.right")
                        .font(.system(size: 9, weight: .bold))
                    Text("Save \(savingsPercent)")
                        .customStyle(.label)
                }
                .foregroundStyle(.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.1), in: Capsule())
                .padding(.top, 8)
            }

            Divider()
                .padding(.top, 12)
                .padding(.bottom, 10)

            // Rating
            HStack(spacing: 4) {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.orange)
                    Text(String(format: "%.1f", rating))
                        .customStyle(.caption)
                        .foregroundStyle(.primary)
                        .monospacedDigit()
                }

                Text("(\(reviewCount))")
                    .customStyle(.footnote)
                    .foregroundStyle(.tertiary)
            }

            // Bottom badge
            HStack(spacing: 4) {
                Image(systemName: badgeColor == .green ? "tag.fill" : "leaf.fill")
                    .font(.system(size: 9))
                Text(badgeText)
                    .customStyle(.label)
                    .textCase(.uppercase)
            }
            .foregroundStyle(badgeColor)
            .padding(.top, 6)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 4)
        )
    }
}

// MARK: – Why Frugal Explanation Card

private struct _WhyFrugalCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(.orange)

                Text("Why Frugal recommends this")
                    .customStyle(.subheadline)
                    .foregroundStyle(.primary)
            }

            VStack(alignment: .leading, spacing: 8) {
                _ReasonRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    text: "Higher quality ingredients for only $1/mo more"
                )
                _ReasonRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    text: "4.8★ rating from 3.4k verified buyers"
                )
                _ReasonRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    text: "Better value per serving long-term"
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 2)
        )
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
