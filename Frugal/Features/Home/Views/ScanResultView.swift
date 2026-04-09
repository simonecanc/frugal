import SwiftUI

struct ScanResultView: View {
    let capturedImage: UIImage
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var showNutrition = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: – Scanned image
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 340)
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
                                    colors: [.black.opacity(0.45), .clear, .clear],
                                    startPoint: .top,
                                    endPoint: .center
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

                    // MARK: – Product info card
                    VStack(alignment: .leading, spacing: 0) {
                        // Title section
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Liquid Egg Whites")
                                    .customStyle(.headline)
                                    .foregroundStyle(.primary)
                                Text("Great Value")
                                    .customStyle(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 22, weight: .regular))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 16)

                        Divider()
                            .padding(.horizontal, 20)

                        // Measurement section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Measurement")
                                .customStyle(.caption)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)

                            HStack {
                                _MeasurementChip(label: "Serving", value: "46g", isSelected: true)
                                _MeasurementChip(label: "100g", value: "100g", isSelected: false)
                                _MeasurementChip(label: "Package", value: "907g", isSelected: false)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)

                        Divider()
                            .padding(.horizontal, 20)

                        // Number of servings
                        HStack {
                            Text("Number of Servings")
                                .customStyle(.body)
                                .foregroundStyle(.primary)

                            Spacer()

                            HStack(spacing: 8) {
                                Text("1")
                                    .customStyle(.body)
                                    .foregroundStyle(.primary)
                                    .monospacedDigit()
                                Image(systemName: "pencil")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)

                        Divider()
                            .padding(.horizontal, 20)

                        // MARK: – Calories
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.orange)

                            Text("25")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)
                                .monospacedDigit()

                            Text("kcal")
                                .customStyle(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 6)

                        Text("Calories")
                            .customStyle(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)

                        // MARK: – Macronutrients
                        HStack(spacing: 12) {
                            _MacroCard(
                                title: "Protein",
                                value: "5",
                                unit: "g",
                                color: .blue,
                                icon: "p.circle.fill"
                            )
                            _MacroCard(
                                title: "Carbs",
                                value: "0",
                                unit: "g",
                                color: .green,
                                icon: "c.circle.fill"
                            )
                            _MacroCard(
                                title: "Fat",
                                value: "0",
                                unit: "g",
                                color: .pink,
                                icon: "f.circle.fill"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, -14) // overlap with image slightly
                    .opacity(showNutrition ? 1 : 0)
                    .offset(y: showNutrition ? 0 : 30)

                    Spacer(minLength: 120)
                }
            }
            .ignoresSafeArea(.container, edges: .top)

            // MARK: – Floating buttons
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
                    Text("Add to Diary")
                        .customStyle(.button)
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
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showNutrition = true
            }
        }
    }
}

// MARK: – Sub-components

private struct _MeasurementChip: View {
    let label: String
    let value: String
    let isSelected: Bool

    var body: some View {
        Text(label)
            .customStyle(.caption)
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? Color.black : Color(.systemGray6))
            )
    }
}

private struct _MacroCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                Text(unit)
                    .customStyle(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .customStyle(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
}
