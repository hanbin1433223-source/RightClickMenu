import SwiftUI

struct PopoverView: View {
    var isQuickPanel: Bool = false
    @State private var searchText = ""

    private var filtered: [FileTypeDef] {
        let list = settings.enabledTypes
        if searchText.isEmpty { return list }
        return list.filter { $0.label.localizedCaseInsensitiveContains(searchText) || $0.ext.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandHeader()
            FileTypePanel(searchText: $searchText, filtered: filtered)
            Rectangle().fill(Color.gray.opacity(0.04)).frame(height: 1)
            if isQuickPanel {
                Text("按 ESC 关闭")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.vertical, 8)
            } else {
                popoverFooter
            }
        }
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }

    @ObservedObject private var settings = SettingsManager.shared

    private var popoverFooter: some View {
        VStack(spacing: 0) {
            Button {
                AppDelegate.shared?.closePopover()
                AppDelegate.shared?.showSettings()
            } label: {
                Label("设置", systemImage: "gearshape")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                NSApp.terminate(nil)
            } label: {
                Label("退出", systemImage: "power")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
