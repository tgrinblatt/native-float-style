---
name: native-float
description: Build macOS Tahoe+ SwiftUI apps using Native Float — a style that feels like a real Apple app with Tyler's personal twist. Uses system fonts, native materials, Tahoe auto-glass on toolbar items, and minimal custom tokens (2 colors total). Identity comes from the HoverToggles cluster (ONE cohesive collapsible toolbar item — magnet/appearance/opacity/pin) and the frosted sidebar treatment (ultraThinMaterial extending into title bar, capsule search, traffic lights on sidebar, inline title row with gear). Use when building native macOS utilities, creating window-managed apps with pin/float/opacity controls, or when the user asks for "Native Float", "Apple-native style", "Quick Copy style", or "HoverToggle pattern".
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

**Standard v3 (2026-06-12; source of truth: the Kaddy app):** ONE `ToolbarItem` containing ONE HStack (`HoverTogglesCluster`) — **magnet · appearance · opacity (a tight 2pt trio) · close › · pin**, collapsible to **[‹ open · a still-FUNCTIONAL pin]** (the most-used toggle stays one click and ⌘P away; the old passive collapsed symbol is retired). NEVER separate items, `ToolbarItemGroup`, or `ControlGroup` (macOS 26's NSToolbar layout tears those apart — the architecture rule since v2). Full spec + complete code: `references/hover-toggles.md`.

```swift
ToolbarItem(id: "hoverToggles", placement: .primaryAction) {
    HoverTogglesCluster(settings: settings)   // one cohesive HStack
}
.customizationBehavior(.disabled)   // locked when the toolbar is customizable
```

**Geometry (probe-measured):** the toolbar inflates default-styled buttons to 36×36 — the capsule interior. Every cluster control is a borderless button in a **30×30 rhythm cell**; cluster spacing **4pt**, tight-trio spacing **2pt**. Smaller visuals sit centered INSIDE their cell via a double frame: the magnet's active halo is **24pt translucent yellow** (glyph in ACCENT — the one deliberate accent-glyph exception), the close toggle's persistent grey circle is **20pt**. First/last controls carry 4pt edge padding; the collapsed chevron leads with 8pt. All dials in one `HoverToggleMetrics` enum.

**On-states** use `HoverToggleStyle` — a 30pt accent circle (white glyph, 3pt gap from the glass), never full-bleed `.toggleStyle(.button)`. `.tint`, never `Color.accentColor` (ignores runtime tint); ABSOLUTE `Color.secondary` for neutral glyphs (hierarchical `.secondary` goes transparent-accent inside toolbar buttons):
```swift
struct HoverToggleStyle: ToggleStyle {
    static let circleDiameter: CGFloat = 30
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            configuration.label
                .labelStyle(.iconOnly)
                .foregroundStyle(configuration.isOn ? AnyShapeStyle(.white) : AnyShapeStyle(Color.secondary))
                .frame(width: Self.circleDiameter, height: Self.circleDiameter)
                .background(Circle().fill(configuration.isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(Color.clear)))
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
    }
}
```

**The controls:** magnet (follow across desktops via `collectionBehavior`; glyph is a template `NSImage` — no SF Symbol exists; active = yellow halo + accent glyph) · appearance (filled icon reflects CURRENT state, ⇧⌘D) · opacity (icon-only button + popover: slider, presets 25/35/50/70/85/100) · close (20pt grey circle, chevron.right) · pin (`.floating` level, ⌘P, 30pt accent circle when on; the collapsed form's pin is ALWAYS circled — accent on / grey off). **Collapse is toolbar PRESSURE:** the flip changes toolbar content width with no window resize — wire the flag into any toolbar fit machinery as an input.

**Collapsible:** a left chevron collapses the cluster to one grey capsule (`secondary.opacity(0.12)`, height 24) holding [expand chevron + app symbol]. State persists in UserDefaults; springs only.

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
- Never SPLIT the HoverToggles across separate ToolbarItems / groups — ONE item, ONE HStack (Standard v2+; the old v1 "separate items" rule is dead)
- Never pass @Bindable to WindowAccessor (use primitive values)
- Never use `.linear` or `.easeIn/.easeOut` (springs only)
- Never add custom backgrounds to toolbar items
- Never use `.windowToolbarStyle(.unified)`
- Never make the sidebar opaque
