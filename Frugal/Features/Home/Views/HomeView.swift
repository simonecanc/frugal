import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // MARK: – Header
                            _HomeHeaderView(searchText: $searchText)

                            // MARK: – Monthly savings card
                            _MonthlySavingsCard(onScanTap: { appState.openCamera() })
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            // MARK: – Categories
                            _CategoriesSection()
                                .padding(.top, 24)

                            // MARK: – Top Frugal Picks
                            _FrugalPicksSection()
                                .padding(.top, 22)

                            // MARK: – Recent Scans
                            _RecentScansSection()
                                .padding(.top, 22)

                            Spacer(minLength: 100)
                        }
                    }

                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(appState.isCameraModalMounted ? .hidden : .visible, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Frugal")
                        .customStyle(.title1)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

// MARK: – Header with Search

private struct _HomeHeaderView: View {
    @Binding var searchText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Good morning 👋")
                .customStyle(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.tertiary)

                TextField("Search a product, brand or store", text: $searchText)
                    .customStyle(.body)
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

// MARK: – Monthly Savings Card

private struct _MonthlySavingsCard: View {
    let onScanTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Main card
            ZStack {
                // Background: Aurora/Mesh Gradient Style
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 24, x: 0, y: 12)
                
                // Subtle colorful "bloom" in the background
                GeometryReader { geo in
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.12))
                            .frame(width: 150, height: 150)
                            .blur(radius: 40)
                            .offset(x: geo.size.width * 0.6, y: -geo.size.height * 0.2)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }

                VStack(spacing: 0) {
                    // Top row: icon + badge
                    HStack(alignment: .top) {
                        // Glassy Leaf icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.white.opacity(0.5))
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.angularGradient(colors: [.green.opacity(0.3), .green.opacity(0.1), .green.opacity(0.3)], center: .center, startAngle: .zero, endAngle: .degrees(360)))
                                )
                                .frame(width: 44, height: 44)
                                .shadow(color: .green.opacity(0.2), radius: 8, x: 0, y: 4)

                            Image(systemName: "leaf.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.linearGradient(colors: [Color(red: 0.2, green: 0.6, blue: 0.3), Color(red: 0.4, green: 0.8, blue: 0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .rotationEffect(.degrees(-10))
                        }

                        Spacer()

                        // Empty styled badge (just the pill)
                        Capsule()
                            .fill(.white)
                            .frame(width: 40, height: 24)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }

                    Spacer()

                    // Bottom row: amount + label
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Total Savings")
                                .customStyle(.label)
                                .textCase(.uppercase)
                                .foregroundStyle(.secondary)
                            
                            Text("$47.50")
                                .customStyle(.display)
                                .monospacedDigit()
                                .foregroundStyle(.primary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("APRIL 2024")
                                .customStyle(.label)
                                .textCase(.uppercase)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(24)
            }
            .frame(height: 170)

            // Scan button below card
            Button(action: onScanTap) {
                HStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder")
                    Text("Scan a product")
                }
                .customFont(.button)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .tint(.black)
        }
    }
}

// MARK: – Categories

private struct _CategoriesSection: View {
    private let categories: [(String, String, Color)] = [
        ("cart.fill", "Grocery", .blue),
        ("drop.fill", "Beverages", .cyan),
        ("leaf.fill", "Organic", .green),
        ("pill.fill", "Health", .pink),
        ("house.fill", "Household", .orange),
        ("tshirt.fill", "Clothing", .purple),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Categories")
                    .customStyle(.title3)
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    // See all categories
                } label: {
                    Text("See all")
                        .customStyle(.footnote)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.1) { icon, name, color in
                        _CategoryChip(icon: icon, name: name, color: color)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct _CategoryChip: View {
    let icon: String
    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 9, style: .continuous))

            Text(name)
                .customStyle(.subheadline)
                .foregroundStyle(.primary)
        }
        .padding(.trailing, 14)
        .padding(.leading, 6)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

// MARK: – Top Frugal Picks

private struct _FrugalPicksSection: View {
    private let picks: [(String, String, Int, Color)] = [
        ("Oat Milk Original", "Oatly", 91, .green),
        ("Greek Yogurt 0%", "Fage", 86, .green),
        ("Peanut Butter", "Kirkland", 78, .blue),
        ("Olive Oil Extra Virgin", "Bertolli", 65, .orange),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Frugal Picks")
                    .customStyle(.title3)
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    // See all picks
                } label: {
                    Text("See all")
                        .customStyle(.footnote)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(picks, id: \.0) { name, brand, score, color in
                        _FrugalPickCard(name: name, brand: brand, score: score, scoreColor: color)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct _FrugalPickCard: View {
    let name: String
    let brand: String
    let score: Int
    let scoreColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Product image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(height: 110)

                Image(systemName: "basket.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(.systemGray4))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .customStyle(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(brand)
                    .customStyle(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.top, 8)
            .padding(.horizontal, 2)

            // Score badge
            HStack(spacing: 4) {
                Circle()
                    .fill(scoreColor)
                    .frame(width: 8, height: 8)
                Text("\(score)/100")
                    .customStyle(.caption)
                    .foregroundStyle(.primary)
                    .monospacedDigit()
            }
            .padding(.top, 4)
            .padding(.horizontal, 2)
        }
        .frame(width: 140)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

// MARK: – Recent Scans (History)

private struct _RecentScansSection: View {
    private let scans: [(String, String, String, Int, Color)] = [
        ("Whole Milk", "Great Value", "2 hours ago", 55, .orange),
        ("Almond Butter", "Justin's", "Yesterday", 88, .green),
        ("Sparkling Water", "LaCroix", "2 days ago", 74, .blue),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Scans")
                    .customStyle(.title3)
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    // See all scans
                } label: {
                    Text("See all")
                        .customStyle(.footnote)
                }
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            VStack(spacing: 2) {
                ForEach(scans, id: \.0) { name, brand, time, score, color in
                    _RecentScanRow(name: name, brand: brand, time: time, score: score, scoreColor: color)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal, 16)
        }
    }
}

private struct _RecentScanRow: View {
    let name: String
    let brand: String
    let time: String
    let score: Int
    let scoreColor: Color

    var body: some View {
        HStack(spacing: 14) {
            // Product icon
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(width: 48, height: 48)
                Image(systemName: "basket.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(.systemGray3))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .customStyle(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text(brand)
                        .customStyle(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(time)
                        .customStyle(.footnote)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            // Score ring
            _ScoreRing(score: score, color: scoreColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct _ScoreRing: View {
    let score: Int
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: 4)
                .frame(width: 44, height: 44)

            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 44, height: 44)
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text("\(score)")
                    .customStyle(.headline)
                    .foregroundStyle(color)
                    .monospacedDigit()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
