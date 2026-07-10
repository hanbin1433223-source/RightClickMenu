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
                            HStack(spacing: 8) {
                                Image(systemName: type.symbol)
                                    .font(.system(size: 15))
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
