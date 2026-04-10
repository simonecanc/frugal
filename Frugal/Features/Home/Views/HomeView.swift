import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack(alignment: .top) {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)

                    _HomeSummaryCard(
                        topInset: proxy.safeAreaInsets.top,
                        availableHeight: proxy.size.height,
                        availableWidth: proxy.size.width
                    )
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(appState.isCameraModalMounted ? .hidden : .visible, for: .tabBar)
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
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(Color.black.opacity(0.7))
            }
            .shadow(color: .black.opacity(0.2), radius: 18, x: 0, y: 8)
        )
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
