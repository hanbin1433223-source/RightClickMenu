import SwiftUI

struct ContentView: View {
    @StateObject private var config = AppConfig.shared

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 18) {
                BrandHeader()

                NavigationLink {
                    GettingStartedView(config: config)
                } label: {
                    Label("开始使用", systemImage: "sparkles")
                }

                NavigationLink {
                    FileTypeList(config: config)
                } label: {
                    Label("文件类型", systemImage: "doc.badge.plus")
                }

                Spacer()
            }
            .padding(20)
            .navigationSplitViewColumnWidth(220)
        } detail: {
            GettingStartedView(config: config)
        }
        .frame(minWidth: 860, minHeight: 560)
        .background(AppTheme.background)
    }
}

private struct BrandHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AppIconMark(size: 64)

            Text("即建")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text("在 Finder 右键，即刻新建文件")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
}

private struct GettingStartedView: View {
    @ObservedObject var config: AppConfig

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("右键，新建文件")
                        .font(.system(size: 42, weight: .bold, design: .rounded))

                    Text("启用 Finder 扩展后，你可以在桌面、文稿、下载等常用目录直接创建文本、Markdown、Word、Excel 和 PPT 文件。")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 14) {
                    StepCard(number: 1, title: "打开系统设置", detail: "进入隐私与安全性里的扩展设置。")
                    StepCard(number: 2, title: "启用即建", detail: "在 Finder 扩展中勾选即建。")
                    StepCard(number: 3, title: "右键创建", detail: "在 Finder 中右键选择即建菜单。")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("已启用的文件类型")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(FileType.allCases) { fileType in
                            FileTypeBadge(fileType: fileType, isEnabled: config.isEnabled(fileType))
                        }
                    }
                }
                .padding(20)
                .background(AppTheme.panel)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(32)
        }
        .background(AppTheme.background)
    }
}

private struct StepCard: View {
    let number: Int
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(number)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 32, height: 32)
                .background(AppTheme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(title)
                .font(.headline)

            Text(detail)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(AppTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct FileTypeBadge: View {
    let fileType: FileType
    let isEnabled: Bool

    var body: some View {
        HStack {
            Text(fileType.displayName)
                .font(.headline)

            Spacer()

            Image(systemName: isEnabled ? "checkmark.circle.fill" : "minus.circle")
                .foregroundStyle(isEnabled ? AppTheme.accent : .secondary)
        }
        .padding(14)
        .background(Color.white.opacity(0.76))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
