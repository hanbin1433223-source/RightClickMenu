import SwiftUI
import AppKit

struct HotKeyRecorder: View {
    @Binding var config: HotKeyConfig
    var onChange: (HotKeyConfig) -> Void

    @State private var isRecording = false
    @State private var breathingOpacity: Double = 1.0

    var body: some View {
        ZStack {
            KeyCaptureView(
                isRecording: $isRecording,
                onCapture: { keyCode, mods in
                    let newConfig = HotKeyConfig(keyCode: keyCode, modifiers: mods)
                    config = newConfig
                    onChange(newConfig)
                    isRecording = false
                },
                onCancel: {
                    isRecording = false
                }
            )
            .frame(width: 0, height: 0)

            Text(displayText)
                .font(.system(.body, design: .monospaced).bold())
                .foregroundStyle(isRecording ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isRecording ? SettingsManager.shared.currentAccentColor.opacity(breathingOpacity) : Color.gray.opacity(0.25), lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isRecording ? SettingsManager.shared.currentAccentColor.opacity(0.06) : Color.clear)
                        )
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    HotKeyManager.shared.unregister()
                    isRecording = true
                }
        }
        .frame(height: 36)
        .help("点击后按下新快捷键")
        .onChange(of: isRecording) { _, recording in
            if recording {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    breathingOpacity = 0.7
                }
            } else {
                breathingOpacity = 1.0
                HotKeyManager.shared.register()
            }
        }
        .onDisappear {
            HotKeyManager.shared.register()
        }
    }

    private var displayText: String {
        if isRecording { return "按下快捷键..." }
        return config.display
    }
}

struct KeyCaptureView: NSViewRepresentable {
    @Binding var isRecording: Bool
    var onCapture: (Int, Int) -> Void
    var onCancel: () -> Void

    func makeNSView(context: Context) -> NSView {
        let v = KeyCaptureNSView()
        v.onCapture = { [self] keyCode, mods in
            guard isRecording else { return }
            onCapture(keyCode, mods)
        }
        v.onCancel = { [self] in
            guard isRecording else { return }
            onCancel()
        }
        v.setActive(isRecording)
        return v
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let v = nsView as? KeyCaptureNSView else { return }
        v.onCapture = { [self] keyCode, mods in
            guard isRecording else { return }
            onCapture(keyCode, mods)
        }
        v.onCancel = { [self] in
            guard isRecording else { return }
            onCancel()
        }
        v.setActive(isRecording)
    }
}

final class KeyCaptureNSView: NSView {
    var onCapture: ((Int, Int) -> Void)?
    var onCancel: (() -> Void)?

    private nonisolated(unsafe) var monitor: Any?
    private nonisolated(unsafe) var active = false

    func setActive(_ active: Bool) {
        self.active = active
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if window != nil {
            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                guard let self, active else { return event }
                let keyCode = Int(event.keyCode)
                if keyCode == 53 {
                    active = false
                    onCancel?()
                    return nil
                }
                let mods = carbonModifiers(from: event.modifierFlags)
                onCapture?(keyCode, mods)
                return nil
            }
        } else {
            removeMonitor()
        }
    }

    deinit {
        removeMonitor()
    }

    private nonisolated func removeMonitor() {
        guard let m = monitor else { return }
        NSEvent.removeMonitor(m)
        monitor = nil
    }

    private func carbonModifiers(from flags: NSEvent.ModifierFlags) -> Int {
        var result = 0
        if flags.contains(.control) { result |= 0x1000 }
        if flags.contains(.option)  { result |= 0x0800 }
        if flags.contains(.shift)   { result |= 0x0200 }
        if flags.contains(.command) { result |= 0x0100 }
        return result
    }
}
