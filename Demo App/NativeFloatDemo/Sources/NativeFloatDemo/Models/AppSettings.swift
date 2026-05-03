import SwiftUI

@MainActor
@Observable
final class AppSettings {
    var windowOpacity: Double {
        didSet { UserDefaults.standard.set(windowOpacity, forKey: "windowOpacity") }
    }

    var windowPinned: Bool {
        didSet { UserDefaults.standard.set(windowPinned, forKey: "windowPinned") }
    }

    var showOnAllDesktops: Bool {
        didSet { UserDefaults.standard.set(showOnAllDesktops, forKey: "showOnAllDesktops") }
    }

    var appearance: String {
        didSet { UserDefaults.standard.set(appearance, forKey: "appearance") }
    }

    init() {
        let defaults = UserDefaults.standard
        defaults.register(defaults: [
            "windowOpacity": 1.0,
            "windowPinned": false,
            "showOnAllDesktops": false,
            "appearance": "system"
        ])

        self.windowOpacity = defaults.double(forKey: "windowOpacity")
        self.windowPinned = defaults.bool(forKey: "windowPinned")
        self.showOnAllDesktops = defaults.bool(forKey: "showOnAllDesktops")
        self.appearance = defaults.string(forKey: "appearance") ?? "system"
    }

    var preferredColorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
