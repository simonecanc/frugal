import SwiftUI

struct HomeView: View {
    @StateObject private var productStore = ProductImageStore.shared
    @State private var summaryCardHeight: CGFloat = 0

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack(alignment: .top) {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)

                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                Color.clear
                                    .frame(height: max(summaryCardHeight - 44, 0))

                            if !productStore.savedItems.isEmpty {
                                _ProductCutoutsGrid(
                                    items: productStore.savedItems,
                                    store: productStore
                                )
                                .padding(.horizontal, 10)
                                .padding(.bottom, 120)
                            } else {
                                Spacer(minLength: 120)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    _HomeSummaryCard(
                        topInset: proxy.safeAreaInsets.top,
                        availableHeight: proxy.size.height,
                        availableWidth: proxy.size.width
                    )
                    .frame(maxWidth: .infinity)
                    .readHeight { summaryCardHeight = $0 }
                    .zIndex(1)
                    .ignoresSafeArea(edges: .top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

private struct _HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private extension View {
    func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: _HeightPreferenceKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(_HeightPreferenceKey.self, perform: onChange)
    }
}

// MARK: – Product Cutouts Grid (collage-style like the reference)

private struct _ProductCutoutsGrid: View {
    let items: [SavedProductItem]
    let store: ProductImageStore

    private let columns = [
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
        GridItem(.flexible(), spacing: 6),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items) { item in
                _ProductCutoutCell(item: item, store: store)
            }
        }
    }
}

private struct _ProductCutoutCell: View {
    let item: SavedProductItem
    let store: ProductImageStore
    @State private var loadedImage: UIImage?
    @State private var appeared = false

    private var displayedRotation: Double {
        min(max(item.rotation, -6), 6)
    }

    var body: some View {
        VStack(spacing: 8) {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .rotationEffect(.degrees(displayedRotation))
                    .scaleEffect(item.scale)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 5)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
            }

            Text(item.productName)
                .font(.system(size: 11, weight: .semibold, design: .default))
                .tracking(-0.3)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 8)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            loadedImage = store.loadImage(for: item)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }
}

private struct _HomeSummaryCard: View {
    let topInset: CGFloat
    let availableHeight: CGFloat
    let availableWidth: CGFloat

    private var textSize: CGFloat {
        availableWidth < 390 ? 16 : 17
    }

    private var cardMinHeight: CGFloat {
        max(availableHeight * 0.25, 210)
    }

    private var topContentPadding: CGFloat {
        topInset + 12
    }

    private var horizontalPadding: CGFloat {
        availableWidth < 390 ? 18 : 20
    }

    private var lineSpacing: CGFloat {
        7
    }

    var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            Text("Frugal")
                .customStyle(.title1)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 12)

            _FlowLayout(alignment: .center, spacing: 4) {
                _summaryText("You've had")
                _MetricPill(icon: "flame.fill", value: "1229", textSize: textSize)
                _summaryText("calories,")
                
                _MetricPill(icon: "circle.grid.2x2.fill", value: "43g", textSize: textSize)
                _summaryText("of protein,")
                
                _MetricPill(icon: "drop.fill", value: "71.5g", textSize: textSize)
                _summaryText("of fat and")
                
                _MetricPill(icon: "moon.fill", value: "109g", textSize: textSize)
                _summaryText("of carbs. The average")
                
                _summaryText("quality of your food")
                _summaryText("today so far is")
                
                _MetricPill(icon: "gauge.medium", value: "8.6", textSize: textSize)
                _summaryText("out of 10.")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topContentPadding)
        .padding(.bottom, 22)
        .frame(minHeight: cardMinHeight, alignment: .topLeading)
        .glassEffect(
            .regular.tint(.black.opacity(0.85)),
            in: .rect(cornerRadius: 34)
        )
        .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 8)
        .environment(\.colorScheme, .dark)
    }

    private func _summaryText(_ value: String) -> some View {
        Text(value)
            .font(.system(size: textSize, weight: .medium, design: .default))
            .tracking(-1.0)
            .foregroundStyle(.primary)
    }
}

struct _FlowLayout: Layout {
    var alignment: Alignment = .leading
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let width = rows.map { $0.width }.max() ?? 0
        let height = rows.map { $0.height }.reduce(0, +) + CGFloat(max(0, rows.count - 1)) * spacing
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            
            if alignment == .center {
                x += (bounds.width - row.width) / 2
            }
            
            for (i, subview) in row.subviews.enumerated() {
                let size = row.sizes[i]
                let yOffset = (row.height - size.height) / 2
                subview.place(at: CGPoint(x: x, y: y + yOffset), proposal: .unspecified)
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [RowData] {
        var rows: [RowData] = []
        var currentSubviews: [LayoutSubview] = []
        var currentSizes: [CGSize] = []
        var currentRowWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRowWidth + size.width > maxWidth && !currentSubviews.isEmpty {
                rows.append(RowData(subviews: currentSubviews, sizes: currentSizes, width: currentRowWidth - spacing, height: currentRowHeight))
                currentSubviews = []
                currentSizes = []
                currentRowWidth = 0
                currentRowHeight = 0
            }
            currentSubviews.append(subview)
            currentSizes.append(size)
            currentRowWidth += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        if !currentSubviews.isEmpty {
            rows.append(RowData(subviews: currentSubviews, sizes: currentSizes, width: currentRowWidth - spacing, height: currentRowHeight))
        }
        return rows
    }

    private struct RowData {
        let subviews: [LayoutSubview]
        let sizes: [CGSize]
        let width: CGFloat
        let height: CGFloat
    }
}

private struct _MetricPill: View {
    let icon: String
    let value: String
    let textSize: CGFloat

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: textSize - 4, weight: .semibold))
                .foregroundStyle(.primary)

            Text(value)
                .font(.system(size: textSize, weight: .medium, design: .default))
                .tracking(-1.0)
                .foregroundStyle(.primary)
                .monospacedDigit()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
