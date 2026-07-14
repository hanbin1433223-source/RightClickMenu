import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = SettingsManager.shared

    private let groupedTypes: [(FileCategory, [FileTypeDef])] = {
        FileCategory.allCases.compactMap { cat in
            let types = FileTypeManager.all.filter { $0.category == cat }
            return types.isEmpty ? nil : (cat, types)
        }
    }()

    private let firstCategory: FileCategory? = {
        FileCategory.allCases.first { cat in
            !FileTypeManager.all.filter { $0.category == cat }.isEmpty
        }
    }()

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
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [settings.currentAccentColor, settings.currentAccentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(settings.currentAccentColor.opacity(0.2), lineWidth: 1.5)
            )
            VStack(alignment: .leading, spacing: 2) {
                Text("即建")
                    .font(.headline)
                Text("在 Finder 右键，即刻新建文件")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.bottom, 16)
    }

    private var hotKeySection: some View {
        VStack(alignment: .leading, spacing: 6) {
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
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        )
        .padding(.bottom, 16)
    }

    private var fileTypesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("文件类型", systemImage: "doc.on.doc")
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)

            ForEach(groupedTypes, id: \.0) { category, types in
                categoryGroup(category, types: types)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.background)
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        )
        .padding(.bottom, 16)
    }

    private func categoryGroup(_ category: FileCategory, types: [FileTypeDef]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if category != firstCategory {
                Rectangle().fill(Color.gray.opacity(0.04)).frame(height: 1)
                    .padding(.vertical, 3)
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(type.brandColor)
                            .frame(width: 24, height: 24)
                            .shadow(color: type.brandColor.opacity(0.3), radius: 2, x: 0, y: 1)
                        Text(type.badgeText)
                            .font(.system(size: type.ext == "json" || type.ext == "xml" ? 7 : 9, weight: .heavy))
                            .foregroundStyle(type.ext == "js" ? Color.black : .white)
                            .lineLimit(1)
                    }
                    .frame(width: 24)
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
        VStack(alignment: .leading, spacing: 6) {
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

            Rectangle().fill(Color.gray.opacity(0.04)).frame(height: 1)
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
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        )
    }
}
