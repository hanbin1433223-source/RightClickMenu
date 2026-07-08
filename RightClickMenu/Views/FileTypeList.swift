import SwiftUI

struct FileTypeList: View {
    @ObservedObject var config: AppConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 8) {
                Text("文件类型")
                    .font(.system(size: 36, weight: .bold, design: .rounded))

                Text("关闭不需要的类型后，Finder 右键菜单会同步隐藏。")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 10) {
                ForEach(FileType.allCases) { fileType in
                    Toggle(isOn: binding(for: fileType)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fileType.menuTitle)
                                .font(.headline)
                            Text(".\(fileType.fileExtension) · 默认名称：\(fileType.baseFileName).\(fileType.fileExtension)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .toggleStyle(.switch)
                    .padding(16)
                    .background(AppTheme.panel)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }

            Spacer()
        }
        .padding(32)
        .background(AppTheme.background)
    }

    private func binding(for fileType: FileType) -> Binding<Bool> {
        Binding {
            config.isEnabled(fileType)
        } set: { isEnabled in
            config.setEnabled(isEnabled, for: fileType)
        }
    }
}
