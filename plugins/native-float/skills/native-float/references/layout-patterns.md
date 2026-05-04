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
                .toolbar {
                    ToolbarItem(placement: .principal) { Spacer() }
                    // HoverToggles (.primaryAction) here
                }
        }
        .navigationSplitViewStyle(.balanced)
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
| Page title | Auto | NavigationSplitView shows selected item's title |
| **Spacer** | **`.principal`** | **Pushes .primaryAction items to far trailing edge** |
| HoverToggles | `.primaryAction` (×3 separate items) | Appearance, Opacity, Pin |
| Action menu | `.primaryAction` | Clear/delete (if applicable) |

**Critical:** The `.toolbar { }` modifier with HoverToggles goes on the **detail content**, NOT on the NavigationSplitView itself. Placing it on NavigationSplitView clusters `.primaryAction` items near the sidebar divider instead of at the far trailing edge.

```swift
NavigationSplitView(columnVisibility: $columnVisibility) {
    SidebarView()
} detail: {
    DetailContent()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Spacer()
            }
            // HoverToggles (.primaryAction) here
        }
}
.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
```

Rules:
- Toolbar goes on the detail view content, not on NavigationSplitView
- Always include the `.principal` Spacer before HoverToggles
- `.toolbarBackgroundVisibility(.hidden)` stays on the NavigationSplitView
- No custom Capsule backgrounds — Tahoe handles glass wrapping
- Each HoverToggle is its own ToolbarItem
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
