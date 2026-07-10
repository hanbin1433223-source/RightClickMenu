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
                Image(systemName: type.symbol)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(settings.currentAccentColor)
                    .frame(width: 22, alignment: .center)
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
            RoundedRectangle(cornerRadius: 6)
                .fill(hovering ? Color.gray.opacity(0.08) : Color.clear)
        )
        .onHover { h in
            withAnimation(.easeInOut(duration: 0.15)) { hovering = h }
        }
        .opacity(type.isInstalled ? 1 : 0.45)
    }
}
