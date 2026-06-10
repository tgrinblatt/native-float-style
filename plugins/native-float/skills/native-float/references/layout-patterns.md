# Layout Patterns

## App Shell

Every Native Float app uses this skeleton:

```swift
@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
```

## NavigationSplitView

```swift
struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            CanvasView()
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            // HoverToggles here
        }
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        .background(WindowAccessor(
            isPinned: settings.windowPinned,
            opacity: settings.windowOpacity,
            showOnAllDesktops: settings.showOnAllDesktops
        ))
    }
}
```

## Toolbar Placement

| Slot | Placement | Content |
|------|-----------|---------|
| Sidebar toggle | `.navigation` | Auto-inserted by NavigationSplitView |
| Title / nav content | `.navigation` | Locked (`.customizationBehavior(.disabled)`) if the toolbar is customizable |
| Principal content | `.principal` | Optional, app-specific (e.g. a pager); good candidate for user customization |
| HoverToggles cluster | `.primaryAction` | ONE item, ONE HStack (`HoverTogglesCluster`) — locked, unsplittable |
| Action menu | `.primaryAction` | Clear/delete (if applicable) |

Rules:
- No custom Capsule backgrounds — Tahoe handles glass wrapping (exception: the cluster's collapsed-state chip)
- The HoverToggles are ONE ToolbarItem containing one HStack — never ×N separate items (v2; NSToolbar tears those apart)
- In a customizable `.toolbar(id:)` window, EVERY item must be customizable-form — one plain `.toolbar {}` item anywhere disables Customize Toolbar… window-wide; lock fixed items with `.customizationBehavior(.disabled)`
- Toolbar item ids are frozen API — the autosaved arrangement keys on them
- Use `.help()` on every toolbar button

## Canvas Grid

```swift
ScrollView {
    LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 200, maximum: 280))],
        spacing: 16
    ) {
        ForEach(items) { item in
            CardView(item: item)
        }
    }
    .padding(24)
}
.scrollIndicators(.hidden)
```

## Sidebar Structure

```
┌─────────────────────────┐
│ ● ● ●  ⊟               │  ← Traffic lights + collapse (auto)
├─────────────────────────┤
│ App Name         ⚙      │  ← Title row
├─────────────────────────┤
│ 🔍 Search               │  ← Capsule search field
├─────────────────────────┤
│ SECTION LABEL           │  ← .caption + .secondary + uppercase
│   📋 Item One           │
│   📋 Item Two           │  ← .listStyle(.sidebar)
│                         │
│ SECTION LABEL           │
│   📁 Item Three         │
│   📁 Item Four          │
└─────────────────────────┘
```

## WindowAccessor (NSViewRepresentable)

```swift
struct WindowAccessor: NSViewRepresentable {
    let isPinned: Bool
    let opacity: Double
    let showOnAllDesktops: Bool

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.delegate = context.coordinator
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }

        window.level = isPinned ? .floating : .normal

        window.isOpaque = opacity >= 1.0
        let bgColor: NSColor = /* light canvas or windowBackground based on appearance */
        window.backgroundColor = bgColor.withAlphaComponent(opacity)

        if showOnAllDesktops {
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        } else {
            window.collectionBehavior = [.fullScreenAuxiliary]
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, NSWindowDelegate {
        func windowShouldClose(_ sender: NSWindow) -> Bool {
            sender.orderOut(nil)
            return false
        }
    }
}
```

Key: Takes primitive values (Bool, Double), NOT @Bindable or @Observable references.

## AppDelegate (Minimal)

```swift
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Title bar transparency for the main window
        if let window = NSApp.windows.first {
            window.titlebarAppearsTransparent = true
            window.backgroundColor = NSColor(/* canvas color */)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false // Hide-on-close, don't quit
    }
}
```
