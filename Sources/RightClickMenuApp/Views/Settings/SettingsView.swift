import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                hotKeySection
                fileTypesSection
                otherSection
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
    }

    private var headerSection: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
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
            VStack(alignment: .leading, spacing: 2) {
                Text("即建")
                    .font(.headline)
                Text("按 \(settings.settings.hotKeyConfig.display) 快速新建文件")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.bottom, 20)
    }

    private var hotKeySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("快捷键", systemImage: "keyboard")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)

            HotKeyRecorder(
                config: Binding(
                    get: { settings.settings.hotKeyConfig },
                    set: { settings.settings.hotKeyConfig = $0 }
                ),
                onChange: { settings.setHotKey($0) }
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .padding(.bottom, 16)
    }

    private var fileTypesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("文件类型", systemImage: "doc.on.doc")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)

            ForEach(FileCategory.allCases, id: \.self) { category in
                let types = FileTypeManager.all.filter { $0.category == category }
                if !types.isEmpty {
                    categoryGroup(category, types: types)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
        .padding(.bottom, 16)
    }

    private func categoryGroup(_ category: FileCategory, types: [FileTypeDef]) -> some View {
        let allNonEmpty = FileCategory.allCases.filter { cat in
            !FileTypeManager.all.filter { $0.category == cat }.isEmpty
        }
        return VStack(alignment: .leading, spacing: 0) {
            if category != allNonEmpty.first {
                Rectangle().fill(Color.gray.opacity(0.06)).frame(height: 1)
                    .padding(.vertical, 4)
            }

            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Text(category.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding(.top, 6)
            .padding(.bottom, 4)

            ForEach(types) { type in
                HStack(spacing: 8) {
                    Image(systemName: type.symbol)
                        .font(.system(size: 14))
                        .foregroundStyle(settings.currentAccentColor)
                        .frame(width: 18, alignment: .center)
                    Text(type.label)
                        .font(.callout)
                        .foregroundStyle(type.isInstalled ? .primary : .secondary)
                    Spacer(minLength: 4)
                    Toggle("", isOn: Binding(
                        get: { settings.isEnabled(type.id) },
                        set: { _ in settings.toggleType(type.id) }
                    ))
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .labelsHidden()
                    .disabled(!type.isInstalled)
                }
                .padding(.vertical, 3)
            }
        }
    }

    private var otherSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("其他", systemImage: "ellipsis.circle")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Image(systemName: "bolt")
                    .font(.system(size: 14))
                    .foregroundStyle(settings.currentAccentColor)
                    .frame(width: 18, alignment: .center)
                Text("快捷键直接创建文件")
                    .font(.callout)
                Spacer(minLength: 4)
                Toggle(isOn: Binding(
                    get: { settings.settings.quickCreateMode },
                    set: { settings.setQuickCreate($0) }
                )) { EmptyView() }
                .toggleStyle(.switch)
                .controlSize(.small)
                .labelsHidden()
            }
            .padding(.vertical, 3)

            Rectangle().fill(Color.gray.opacity(0.06)).frame(height: 1)
                .padding(.vertical, 3)

            HStack(spacing: 8) {
                Image(systemName: "power")
                    .font(.system(size: 14))
                    .foregroundStyle(settings.currentAccentColor)
                    .frame(width: 18, alignment: .center)
                Text("开机自启")
                    .font(.callout)
                Spacer(minLength: 4)
                Toggle(isOn: Binding(
                    get: { settings.settings.launchOnLogin },
                    set: { settings.setLaunchOnLogin($0) }
                )) { EmptyView() }
                .toggleStyle(.switch)
                .controlSize(.small)
                .labelsHidden()
            }
            .padding(.vertical, 3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }
}
