# Anti-Patterns

Things that violate Native Float's identity and principles.

## Typography

- **Never** use `.custom()` fonts — system fonts only
- **Never** bundle fonts (Geist, Inter, etc.) — this isn't tyler-app-style
- **Never** hardcode font sizes — use semantic styles (`.title`, `.body`, `.caption`)
- **Never** use `.monospaced()` for body text — only for numeric data via `.monospacedDigit()`

## Colors

- **Never** define custom hex color palettes — only 2 custom values exist (#EBEFEF, #282828)
- **Never** hardcode colors inline — use system values or the 2 tokens
- **Never** override `.accentColor` to a brand color — respect user's system preference
- **Never** use color as the sole differentiator — always pair with icon/text

## Glass & Materials

- **Never** apply `.glassEffect()` manually to views — let Tahoe handle toolbar glass
- **Never** use `GlassEffectContainer` — that's tyler-app-style
- **Never** use `.buttonStyle(.glass)` — let the toolbar item placement handle it
- **Never** add `Capsule()` backgrounds under toolbar items — doubles up with Tahoe glass
- **Never** make the sidebar opaque — `.ultraThinMaterial` is load-bearing for the identity

## Toolbar

- **Never** combine HoverToggle items into one `ToolbarItem`
- **Never** wrap HoverToggles in a `ToolbarItemGroup`
- **Never** put HoverToggles in an `HStack` inside a single item
- **Never** use `.windowToolbarStyle(.unified)` — re-enables opaque title bar background
- **Never** add `.toolbarBackground(.visible)` — fights the hidden title bar
- **Never** use `.toolbar(.hidden)` on the window toolbar

## WindowAccessor

- **Never** pass `@Bindable settings` to WindowAccessor — use primitive values (Bool, Double)
- **Never** pass an `@Observable` class to WindowAccessor — struct properties must differ to trigger update
- **Never** access windows via `NSApp.windows.first` in view bodies — use the `.background()` pattern
- **Never** use `onAppear` to configure the window — race condition with window creation

## Sidebar

- **Never** override `.listStyle` explicitly on sidebar lists — NavigationSplitView sets `.sidebar` automatically
- **Never** replace NavigationSplitView with a manual HStack sidebar
- **Never** add a custom sidebar collapse button — NavigationSplitView inserts one at `.navigation`
- **Never** put the app title in the toolbar — it lives in the sidebar title row
- **Never** use a round search field — always Capsule shape

## Animation

- **Never** use `.linear` animations
- **Never** use `.easeIn` or `.easeOut` (exception: opacity preset selection uses `.easeOut(duration: 0.15)`)
- **Never** use `withAnimation { }` without specifying a spring
- **Never** animate frame changes for selection feedback — use `.scaleEffect` (no reflow)

## Architecture

- **Never** use an Xcode project — SPM via Package.swift only
- **Never** use NSHostingController for the main window — pure SwiftUI scene tree
- **Never** subclass NSWindow — WindowAccessor handles everything needed
- **Never** create a separate Settings window for primary settings — use in-canvas SettingsCards
- **Never** use `@Published` — use `@Observable` (Swift 6 observation)

## What to Do Instead

| Anti-Pattern | Correct Approach |
|-------------|-----------------|
| `.custom("MyFont", size: 14)` | `.font(.body)` |
| `Color(hex: "FF5500")` | `.accentColor` or system color |
| `.glassEffect()` on a button | `ToolbarItem(placement: .primaryAction)` |
| `ToolbarItemGroup { HStack { ... } }` | Three separate `ToolbarItem(.primaryAction)` |
| `@Bindable var settings` in WindowAccessor | `let isPinned: Bool, let opacity: Double` |
| `withAnimation(.linear) { }` | `withAnimation(NativeFloatTokens.Motion.selection) { }` |
| Manual sidebar with `.frame(width: 220)` | `NavigationSplitView` with `.navigationSplitViewColumnWidth()` |
| Custom toggle with circles/icons | `Toggle(isOn:) { }.toggleStyle(.button)` |
| `RoundedRectangle(cornerRadius: 8)` | `RoundedRectangle(cornerRadius: 8, style: .continuous)` |
