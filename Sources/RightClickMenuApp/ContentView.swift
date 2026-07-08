import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(.tint)

            Text("即建")
                .font(.largeTitle.weight(.bold))

            Text("在 Finder 右键，即刻新建文件")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                Text("使用说明")
                    .font(.headline)
                    .padding(.top, 4)

                Group {
                    HStack(spacing: 8) {
                        Image(systemName: "1.circle.fill")
                            .foregroundStyle(.tint)
                        Text("点击菜单栏 \(Image(systemName: "doc.badge.plus")) → 选择文件类型")
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "2.circle.fill")
                            .foregroundStyle(.tint)
                        Text("按快捷键 ")
                            + Text("⌥⌘N").font(.body.monospaced().bold())
                            + Text(" 弹出类型选择窗口")
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "3.circle.fill")
                            .foregroundStyle(.tint)
                        Text("文件创建在当前访达窗口位置或桌面")
                    }
                }
                .font(.callout)

                Divider()
                    .padding(.vertical, 4)

                Text("提示：如果打开设置窗口没有响应，请先点击 即建 → 打开设置")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .frame(minWidth: 480, minHeight: 360)
    }
}
