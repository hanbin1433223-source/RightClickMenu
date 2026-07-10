import SwiftUI

struct QuickPanelView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var searchText = ""

    private var filtered: [FileTypeDef] {
        let list = settings.enabledTypes
        if searchText.isEmpty { return list }
        return list.filter { $0.label.localizedCaseInsensitiveContains(searchText) || $0.ext.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandHeader()
            if !settings.enabledTypes.isEmpty {
                searchBar
                Divider()
            }
            typeList
            Divider()
            Text("按 ESC 关闭")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.vertical, 8)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }

    private var searchBar: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.caption)
            TextField("搜索文件类型...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.callout)
                .frame(height: 20)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var typeList: some View {
        ScrollView {
            VStack(spacing: 0) {
                if filtered.isEmpty {
                    VStack(spacing: 4) {
                        Image(systemName: "tray")
                            .font(.title2)
                            .foregroundStyle(.tertiary)
                        Text(searchText.isEmpty ? "还没有启用文件类型" : "没有匹配的类型")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 40)
                } else {
                    ForEach(grouped, id: \.category) { group in
                        if !group.types.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(group.category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .textCase(.uppercase)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 10)
                                    .padding(.bottom, 4)
                                ForEach(Array(group.types.enumerated()), id: \.offset) { i, type in
                                    TypeRow(
                                        type: type,
                                        onSelect: { FileCreator.create(type.ext) }
                                    )
                                    if i == group.types.count - 1 {
                                        Divider().opacity(0)
                                            .padding(.bottom, 4)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .frame(maxHeight: 300)
    }

    private var grouped: [CategoryGroup] {
        let cats = Set(filtered.map(\.category))
        return cats.sorted { $0.rawValue < $1.rawValue }.map { cat in
            CategoryGroup(category: cat, types: filtered.filter { $0.category == cat })
        }
    }
}

private struct CategoryGroup {
    let category: FileCategory
    let types: [FileTypeDef]
}
