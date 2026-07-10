import SwiftUI

struct FileTypesTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            ForEach(FileCategory.allCases, id: \.self) { category in
                let types = FileTypeManager.all.filter { $0.category == category }
                if !types.isEmpty {
                    Section {
                        ForEach(types) { type in
                            Toggle(isOn: Binding(
                                get: { settings.isEnabled(type.id) },
                                set: { _ in settings.toggleType(type.id) }
                            )) {
                                Label(type.label, systemImage: type.symbol)
                                    .foregroundStyle(type.isInstalled ? .primary : .secondary)
                            }
                            .toggleStyle(.switch)
                            .disabled(!type.isInstalled)
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.icon)
                    }
                }
            }
        }
        .listStyle(.bordered)
    }
}
