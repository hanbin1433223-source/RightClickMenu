import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var step = 1
    @State private var selectedTypeIDs: Set<String> = ["txt", "md", "rtf", "html", "css", "js"]

    let totalSteps = 3

    var body: some View {
        VStack(spacing: 0) {
            progressBar
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            footer
        }
        .frame(width: 440, height: 500)
    }

    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { s in
                Capsule()
                    .fill(s <= step ? settings.currentAccentColor : Color.gray.opacity(0.15))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 24)
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private var content: some View {
        switch step {
        case 1: welcomeView
        case 2: typeSelectionView
        case 3: completionView
        default: EmptyView()
        }
    }

    private var welcomeView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(settings.currentAccentColor)

            Text("欢迎使用即建")
                .font(.title2.weight(.bold))

            Text("在 Finder 右键，即刻新建文件")
                .foregroundStyle(.secondary)

            Text("支持 19 种文件类型，快速创建常用文档")
                .font(.callout)
                .foregroundStyle(.tertiary)

            HStack(spacing: 14) {
                ForEach(["indigo", "blue", "purple", "orange", "green", "red"], id: \.self) { colorName in
                    let color = colorForName(colorName)
                    let isSelected = settings.settings.accentColor == colorName
                    Circle()
                        .fill(color)
                        .frame(width: 26, height: 26)
                        .shadow(color: isSelected ? color.opacity(0.4) : .clear, radius: 4, x: 0, y: 2)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2.5)
                                .opacity(isSelected ? 1 : 0)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                settings.setAccentColor(colorName)
                            }
                        }
                        .scaleEffect(isSelected ? 1.15 : 1.0)
                        .animation(.spring(duration: 0.3), value: settings.settings.accentColor)
                }
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(.horizontal, 40)
        .multilineTextAlignment(.center)
    }

    private var typeSelectionView: some View {
        VStack(spacing: 10) {
            Text("选择常用文件类型")
                .font(.headline)
            Text("可在设置中随时调整")
                .font(.caption)
                .foregroundStyle(.secondary)

            List(FileTypeManager.all) { type in
                Toggle(isOn: Binding(
                    get: { selectedTypeIDs.contains(type.id) },
                    set: { on in
                        if on { selectedTypeIDs.insert(type.id) }
                        else { selectedTypeIDs.remove(type.id) }
                    }
                )) {
                    Label(type.label, systemImage: type.symbol)
                        .font(.callout)
                }
                .toggleStyle(.switch)
                .controlSize(.small)
            }
            .listStyle(.bordered)
        }
        .padding(.horizontal, 28)
    }

    private var completionView: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(settings.currentAccentColor)

            Text("设置完成")
                .font(.title2.weight(.bold))

            Text("点击菜单栏 ") + Text(Image(systemName: "doc.badge.plus")).foregroundStyle(settings.currentAccentColor) + Text(" 或按快捷键 ") + Text("\(settings.settings.hotKeyConfig.display)").font(.body.monospaced().bold()) + Text(" 快速新建文件")

            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }

    private var footer: some View {
        HStack {
            if step > 1 {
                Button("上一步") {
                    withAnimation(.easeInOut(duration: 0.2)) { step -= 1 }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            Spacer()

            if step < totalSteps {
                Button("下一步") {
                    withAnimation(.easeInOut(duration: 0.2)) { step += 1 }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .keyboardShortcut(.return)
            } else {
                Button("开始使用") {
                    settings.completeOnboarding(
                        typeIDs: Array(selectedTypeIDs)
                    )
                    if let win = NSApp.keyWindow { win.close() }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .keyboardShortcut(.return)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
    }

    private func colorForName(_ name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "purple": return .purple
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        default: return .indigo
        }
    }
}
