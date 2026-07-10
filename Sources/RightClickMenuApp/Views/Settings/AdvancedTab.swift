import SwiftUI

struct AdvancedTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "keyboard")
                        .font(.system(size: 15))
                        .foregroundStyle(settings.currentAccentColor)
                        .frame(width: 18, alignment: .center)
                    Text("快捷键")
                        .font(.callout)
                    Spacer()
                    HotKeyRecorder(
                        config: Binding(
                            get: { settings.settings.hotKeyConfig },
                            set: { settings.settings.hotKeyConfig = $0 }
                        ),
                        onChange: { settings.setHotKey($0) }
                    )
                    .frame(width: 180)
                }
                .listRowSeparator(.hidden)
            } header: {
                Label("快捷键", systemImage: "keyboard")
            }

            Section {
                HStack {
                    Image(systemName: "bolt")
                        .font(.system(size: 15))
                        .foregroundStyle(settings.currentAccentColor)
                        .frame(width: 18, alignment: .center)
                    Text("按快捷键时直接创建，不弹出选择")
                        .font(.callout)
                    Spacer(minLength: 4)
                    Toggle(isOn: Binding(
                        get: { settings.settings.quickCreateMode },
                        set: { settings.setQuickCreate($0) }
                    )) {
                        EmptyView()
                    }
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .labelsHidden()
                }
                .listRowSeparator(.hidden)

                if settings.settings.quickCreateMode {
                    HStack {
                        Image(systemName: "filemenu.and.selection")
                            .font(.system(size: 15))
                            .foregroundStyle(settings.currentAccentColor)
                            .frame(width: 18, alignment: .center)
                        Text("默认类型")
                            .font(.callout)
                        Spacer()
                        Picker("", selection: Binding(
                            get: { settings.settings.defaultTypeID },
                            set: { settings.setDefaultType($0) }
                        )) {
                            ForEach(settings.enabledTypes) { type in
                                Text(type.label).tag(type.id)
                            }
                        }
                        .labelsHidden()
                    }
                    .listRowSeparator(.hidden)
                }
            } header: {
                Label("快速创建", systemImage: "bolt")
            }

            Section {
                HStack {
                    Image(systemName: "power")
                        .font(.system(size: 15))
                        .foregroundStyle(settings.currentAccentColor)
                        .frame(width: 18, alignment: .center)
                    Text("开机后自动运行即建")
                        .font(.callout)
                    Spacer(minLength: 4)
                    Toggle(isOn: Binding(
                        get: { settings.settings.launchOnLogin },
                        set: { settings.setLaunchOnLogin($0) }
                    )) {
                        EmptyView()
                    }
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .labelsHidden()
                }
                .listRowSeparator(.hidden)
            } header: {
                Label("启动", systemImage: "power")
            }
        }
        .listStyle(.bordered)
    }
}
