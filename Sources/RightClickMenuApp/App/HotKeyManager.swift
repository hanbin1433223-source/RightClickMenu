import Carbon

@MainActor
final class HotKeyManager: @unchecked Sendable {
    static let shared = HotKeyManager()
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reRegister),
            name: .hotKeyConfigChanged,
            object: nil
        )
    }

    func register() {
        unregister()
        let config = SettingsManager.shared.settings.hotKeyConfig
        let keyCode = UInt32(config.keyCode)
        let mods = UInt32(config.modifiers)

        let sig = "JIJN".utf8.reduce(OSType(0)) { ($0 << 8) | OSType($1) }
        let id = EventHotKeyID(signature: sig, id: 1)
        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(keyCode, mods, id, GetApplicationEventTarget(), 0, &ref)
        if status != noErr {
            NSLog("即建: RegisterEventHotKey failed: \(status)")
        }
        hotKeyRef = ref

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, event, _ -> OSStatus in
            var hkID = EventHotKeyID()
            GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hkID)
            if hkID.id == 1 {
                Task { @MainActor in AppDelegate.shared?.handleHotKey() }
            }
            return noErr
        }, 1, &eventType, nil, &eventHandler)
    }

    func unregister() {
        if let ref = hotKeyRef { UnregisterEventHotKey(ref); hotKeyRef = nil }
        if let ref = eventHandler { RemoveEventHandler(ref); eventHandler = nil }
    }

    @objc private func reRegister() {
        register()
    }
}
