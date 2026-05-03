---
name: native-float
description: Build macOS Tahoe+ SwiftUI apps using Native Float — a style that feels like a real Apple app with Tyler's personal twist. Uses system fonts, native materials, Tahoe auto-glass on toolbar items, and minimal custom tokens (2 colors total). Identity comes from the HoverToggles cluster (appearance/opacity/pin as separate .primaryAction toolbar items) and the frosted sidebar treatment (ultraThinMaterial extending into title bar, capsule search, traffic lights on sidebar, inline title row with gear). Use when building native macOS utilities, creating window-managed apps with pin/float/opacity controls, or when the user asks for "Native Float", "Apple-native style", "Quick Copy style", or "HoverToggle pattern".
---

# Native Float

A macOS Tahoe+ SwiftUI style that feels like a first-party Apple app. System fonts, native materials, minimal custom design tokens. The identity is behavioral — the HoverToggles cluster and frosted sidebar treatment.

## When to Use

- Building a native macOS SwiftUI utility app (macOS 26+)
- User asks for "Native Float", "native macOS app", "Apple-native style"
- User wants pin/float/opacity window management with system-native look
- User asks for "Quick Copy style" or "HoverToggle pattern"
- Building a tool that should feel like Apple Notes/Finder/Calendar

## When NOT to Use

- User asks for tyler-app-style / Liquid Glass / Geist fonts
- User wants custom hex color palettes or branded design systems
- Building for iOS, visionOS, or other non-macOS platforms
- User wants explicit `.glassEffect()` application

## Core Principles

1. **System fonts only** — semantic text styles (`.title`, `.body`, `.caption`), never `.custom()`
2. **System colors first** — only 2 custom values exist (light canvas #EBEFEF, dark card #282828)
3. **Let Tahoe handle glass** — separate `.primaryAction` items get auto-grouped with glass
4. **Springs only** — two springs cover the entire motion system
5. **Minimal WindowAccessor** — bridge to NSWindow takes primitive values, not Observable
6. **NavigationSplitView** — the sidebar framework, not manual implementations

## Platform Requirements

- macOS 26+ (Tahoe) for native toolbar glass grouping
- Swift 6.0+ (strict concurrency)
- Swift Package Manager (no Xcode project)
- SF Symbols for all icons

## Design Tokens

```swift
enum NativeFloatTokens {
    enum Color {
        static let lightCanvas = SwiftUI.Color(red: 235/255, green: 239/255, blue: 239/255)
        static let darkCard = SwiftUI.Color(red: 40/255, green: 40/255, blue: 40/255)
    }
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }
    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 10
    }
    enum Motion {
        static let selection = Animation.spring(response: 0.28, dampingFraction: 0.7)
        static let layout = Animation.spring(response: 0.35, dampingFraction: 0.75)
    }
}
```

## Identity Mark 1: HoverToggles Cluster

Three SEPARATE `ToolbarItem(.primaryAction)` items. Tahoe auto-groups them visually.

**Appearance Toggle** — binary light/dark switch:
```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: { toggleAppearance() }) {
        Image(systemName: colorScheme == .dark ? "sun.max" : "moon")
    }
    .help("Toggle appearance (⇧⌘D)")
    .keyboardShortcut("d", modifiers: [.shift, .command])
}
```

**Opacity Control** — button with popover:
```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: { showOpacityPopover = true }) {
        HStack(spacing: 4) {
            Image(systemName: opacityIcon)
            Text("\(Int(opacity * 100))%")
                .font(.caption).monospacedDigit()
        }
    }
    .popover(isPresented: $showOpacityPopover, arrowEdge: .bottom) {
        // Slider + 6 presets: 25, 35, 50, 70, 85, 100
    }
}
```

**Pin Toggle** — native blue accent when active:
```swift
ToolbarItem(placement: .primaryAction) {
    Toggle(isOn: $settings.windowPinned) {
        Image(systemName: "pin")
    }
    .toggleStyle(.button)
    .help("Pin window (⌘P)")
    .keyboardShortcut("p", modifiers: .command)
}
```

## Identity Mark 2: Frosted Sidebar

```swift
NavigationSplitView(columnVisibility: $columnVisibility) {
    VStack(alignment: .leading, spacing: 0) {
        // Title row (inline with traffic lights)
        HStack {
            Text("App Name").font(.headline).fontWeight(.semibold)
            Spacer()
            Button { /* settings */ } label: {
                Image(systemName: "gearshape").foregroundStyle(.secondary)
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, 16).padding(.top, 12)

        // Capsule search
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Search", text: $searchText).textFieldStyle(.plain)
        }
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(nsColor: .separatorColor), lineWidth: 0.5))
        .padding(.horizontal, 12).padding(.top, 12)

        // Section list
        List(selection: $selectedItem) { ... }
            .listStyle(.sidebar)
    }
    .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
} detail: {
    // Canvas content
}
.navigationSplitViewStyle(.balanced)
```

## WindowAccessor Bridge

```swift
struct WindowAccessor: NSViewRepresentable {
    let isPinned: Bool
    let opacity: Double
    let showOnAllDesktops: Bool

    func makeNSView(context: Context) -> NSView { NSView() }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }
        window.level = isPinned ? .floating : .normal
        window.isOpaque = opacity >= 1.0
        window.backgroundColor = NSColor(/* canvas color */).withAlphaComponent(opacity)
        // ... collectionBehavior for allDesktops
    }
}
```

Usage: `.background(WindowAccessor(isPinned: settings.windowPinned, opacity: settings.windowOpacity, showOnAllDesktops: settings.showOnAllDesktops))`

## Window Setup

```swift
// App scene
WindowGroup { ContentView() }
    .windowStyle(.hiddenTitleBar)

// Root view
.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
```

## Anti-Patterns

- Never use `.custom()` fonts
- Never apply `.glassEffect()` manually
- Never combine HoverToggles into one ToolbarItem
- Never pass @Bindable to WindowAccessor (use primitive values)
- Never use `.linear` or `.easeIn/.easeOut` (springs only)
- Never add custom backgrounds to toolbar items
- Never use `.windowToolbarStyle(.unified)`
- Never make the sidebar opaque
