import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Sfondo sistema (Light Mode)
                Color(UIColor.systemBackground)
                    .ignoresSafeArea(.all)
                
                // Contenuto scrollabile
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Frugal")
                        .customStyle(.title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
