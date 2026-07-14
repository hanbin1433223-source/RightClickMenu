import SwiftUI

struct BrandHeader: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [settings.currentAccentColor, settings.currentAccentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
            Text("即建")
                .font(.headline)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.04))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}
