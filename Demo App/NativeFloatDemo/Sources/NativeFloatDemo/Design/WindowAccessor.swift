import SwiftUI
import AppKit

struct WindowAccessor: NSViewRepresentable {
    let isPinned: Bool
    let opacity: Double
    let showOnAllDesktops: Bool

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            configureOnce(window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            guard let window = nsView.window else { return }
            applyDynamicState(window)
        }
    }

    private func configureOnce(_ window: NSWindow) {
        if window.delegate !== HideOnCloseDelegate.shared {
            HideOnCloseDelegate.shared.previous = window.delegate
            window.delegate = HideOnCloseDelegate.shared
        }
        applyDynamicState(window)
    }

    private func applyDynamicState(_ window: NSWindow) {
        window.level = isPinned ? .floating : .normal
        window.collectionBehavior = showOnAllDesktops
            ? [.canJoinAllSpaces, .fullScreenAuxiliary]
            : [.moveToActiveSpace]
        window.isOpaque = false
        window.backgroundColor = dynamicBackgroundColor(opacity: opacity)
    }

    private func dynamicBackgroundColor(opacity: Double) -> NSColor {
        let lightCanvas = NSColor(red: 235 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1.0)
        return NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
            let resolvedColor: NSColor
            if isDark {
                var resolved: NSColor = .windowBackgroundColor
                appearance.performAsCurrentDrawingAppearance {
                    resolved = .windowBackgroundColor
                }
                resolvedColor = resolved
            } else {
                resolvedColor = lightCanvas
            }
            return resolvedColor.withAlphaComponent(CGFloat(opacity))
        }
    }
}

@MainActor
private final class HideOnCloseDelegate: NSObject, NSWindowDelegate {
    static let shared = HideOnCloseDelegate()

    weak var previous: NSWindowDelegate?

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }

    nonisolated override func responds(to aSelector: Selector!) -> Bool {
        super.responds(to: aSelector)
    }

    nonisolated override func forwardingTarget(for aSelector: Selector!) -> Any? {
        nil
    }
}
