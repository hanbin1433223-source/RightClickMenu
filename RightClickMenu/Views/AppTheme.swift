import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.09, green: 0.62, blue: 0.62)
    static let background = LinearGradient(
        colors: [Color(red: 0.97, green: 0.99, blue: 0.98), Color(red: 0.89, green: 0.94, blue: 0.93)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let panel = Color.white.opacity(0.74)
}

struct AppIconMark: View {
    let size: CGFloat

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(LinearGradient(colors: [Color.white, Color(red: 0.72, green: 0.9, blue: 1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size, height: size)
                .shadow(color: .teal.opacity(0.2), radius: 14, x: 0, y: 8)

            Image(systemName: "doc")
                .font(.system(size: size * 0.48, weight: .semibold))
                .foregroundStyle(Color(red: 0.11, green: 0.34, blue: 0.36))
                .offset(x: -size * 0.06, y: -size * 0.06)

            Image(systemName: "plus")
                .font(.system(size: size * 0.22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: size * 0.34, height: size * 0.34)
                .background(LinearGradient(colors: [Color(red: 0.09, green: 0.62, blue: 0.62), Color(red: 0.23, green: 0.49, blue: 0.94)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedRectangle(cornerRadius: size * 0.1, style: .continuous))
                .offset(x: size * 0.08, y: size * 0.08)
        }
        .frame(width: size, height: size)
    }
}
