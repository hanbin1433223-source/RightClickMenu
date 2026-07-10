import SwiftUI

struct AdvancedTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            Section {
                HStack {
                    Text("快捷键")
                    Spacer()
                    HotKeyRecorder(
                        config: Binding(
                            get: { settings.settings.hotKeyConfig },
                            set: { settings.settings.hotKeyConfig = $0 }
                        ),
                        onChange: { settings.setHotKey($0) }
                    )
                    .frame(width: 200)
                }
                .padding(.vertical, 2)
            } header: {
                Label("快捷键", systemImage: "keyboard")
            }

            Section {
                Toggle(isOn: Binding(
                    get: { settings.settings.quickCreateMode },
                    set: { settings.setQuickCreate($0) }
                )) {
                    Text("按快捷键时直接创建，不弹出选择")
                }

                if settings.settings.quickCreateMode {
                    HStack {
                        Text("默认类型")
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
                }
            } header: {
                Label("快速创建", systemImage: "bolt")
            }

            Section {
                Toggle(isOn: Binding(
                    get: { settings.settings.launchOnLogin },
                    set: { settings.setLaunchOnLogin($0) }
                )) {
                    Text("开机后自动运行即建")
                }
            } header: {
                Label("启动", systemImage: "power")
            }
        }
        .listStyle(.bordered)
    }
}
