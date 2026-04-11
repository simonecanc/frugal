import SwiftUI

struct SavedView: View {
    private let savedProducts: [(String, String, String, String, Int, Color)] = [
        ("Kirkland Signature Cashews", "Kirkland", "$12.99", "$0.87/100g", 86, .green),
        ("Oat Milk Original", "Oatly", "$4.49", "$0.45/100g", 91, .green),
        ("Cage-Free Egg Whites", "Kirkland", "$3.49", "$0.26/100g", 82, .blue),
        ("Greek Yogurt 0%", "Fage", "$5.99", "$0.65/100g", 86, .green),
        ("Whole Milk", "Great Value", "$2.47", "$0.27/100g", 55, .orange)
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.all)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(savedProducts, id: \.0) { name, brand, price, pricePerUnit, score, color in
                                _SavedProductRow(
                                    name: name,
                                    brand: brand,
                                    price: price,
                                    pricePerUnit: pricePerUnit,
                                    score: score,
                                    scoreColor: color
                                )
                            }
                            
                            // Extra space at bottom
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
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

private struct _SavedProductRow: View {
    let name: String
    let brand: String
    let price: String
    let pricePerUnit: String
    let score: Int
    let scoreColor: Color

    var body: some View {
        HStack(spacing: 14) {
            // Product image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "basket.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.systemGray4))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(brand)
                    .customStyle(.label)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                
                Text(name)
                    .customStyle(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Text(price)
                        .customStyle(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("·")
                        .foregroundStyle(.tertiary)
                    
                    Text(pricePerUnit)
                        .customStyle(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Frugal Score badge
            VStack(alignment: .trailing, spacing: 6) {
                _FrugalScoreBadgeMini(score: score, color: scoreColor)
                
                Button(action: {}) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
        )
    }
}

private struct _FrugalScoreBadgeMini: View {
    let score: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            
            Text("\(score)")
                .customStyle(.caption)
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    SavedView()
        .environmentObject(AppState())
}
