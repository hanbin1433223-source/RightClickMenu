import SwiftUI

struct UsageTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Spacer().frame(height: 8)
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [settings.currentAccentColor, settings.currentAccentColor.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)
                    }

                    Text("即建")
                        .font(.title.weight(.bold))

                    Text("在 Finder 右键，即刻新建文件")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Spacer().frame(height: 8)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                Label {
                    Text("点击菜单栏图标，选择文件类型")
                } icon: {
                    Image(systemName: "1.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)

                Label {
                    Text("或按快捷键 \(settings.settings.hotKeyConfig.display)，选择类型")
                } icon: {
                    Image(systemName: "2.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)

                Label {
                    Text("文件创建在当前访达窗口位置或桌面")
                } icon: {
                    Image(systemName: "3.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)
            } header: {
                Label("使用步骤", systemImage: "list.number")
            }
        }
        .listStyle(.bordered)
    }
}
