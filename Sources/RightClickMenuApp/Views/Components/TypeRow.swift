import SwiftUI

struct TypeRow: View {
    let type: FileTypeDef
    var showToggle: Bool = false
    var isToggleOn: Bool = false
    var onToggle: ((Bool) -> Void)?
    var onSelect: (() -> Void)?

    @State private var hovering = false
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        Button {
            if showToggle {
                onToggle?(!isToggleOn)
            } else {
                onSelect?()
            }
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(
                            LinearGradient(
                                colors: [settings.currentAccentColor.opacity(0.15), settings.currentAccentColor.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 30, height: 30)
                    Image(systemName: type.symbol)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(settings.currentAccentColor)
                }
                Text(type.label)
                    .font(.callout)
                    .foregroundStyle(!type.isInstalled ? .secondary : .primary)
                if !type.isInstalled {
                    Text("未安装")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.08)))
                }
                Spacer()
                if showToggle {
                    Toggle("", isOn: Binding(
                        get: { isToggleOn },
                        set: { onToggle?($0) }
                    ))
                    .disabled(!type.isInstalled)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                } else {
                    Text(type.ext.uppercased())
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.08)))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(hovering ? settings.currentAccentColor.opacity(0.08) : Color.clear)
        )
        .scaleEffect(hovering ? 0.98 : 1.0)
        .animation(.spring(duration: 0.2), value: hovering)
        .onHover { h in
            withAnimation(.easeInOut(duration: 0.15)) { hovering = h }
            if h { NSCursor.pointingHand.push() } else { NSCursor.pop() }
        }
        .opacity(type.isInstalled ? 1 : 0.45)
    }
}
