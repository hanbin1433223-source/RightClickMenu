import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var selectedTab: SettingsTab = .usage

    enum SettingsTab: String, CaseIterable, Hashable {
        case usage = "使用说明"
        case fileTypes = "文件类型"
        case advanced = "高级"

        var icon: String {
            switch self {
            case .usage: return "info.circle"
            case .fileTypes: return "doc.on.doc"
            case .advanced: return "gearshape"
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                ForEach(SettingsTab.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: tab.icon)
                        .tag(tab)
                }
            }
            .listStyle(.sidebar)
            .tint(settings.currentAccentColor)
            .navigationSplitViewColumnWidth(min: 220, ideal: 220, max: 260)
        } detail: {
            detailContent
                .id(selectedTab)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.02), Color.gray.opacity(0.06)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(minWidth: 640, minHeight: 480)
    }

    @ViewBuilder
    private var detailContent: some View {
        switch selectedTab {
        case .usage: UsageTab()
        case .fileTypes: FileTypesTab()
        case .advanced: AdvancedTab()
        }
    }
}
