# Native Float Demo — Working Rules

## Overview

This is a visual reference app demonstrating the Native Float macOS Tahoe+ style. Every view exists to showcase UI patterns — no real data models or business logic.

## Rules

1. **System fonts only** — Never use `.custom()`. Always semantic text styles.
2. **System colors first** — Only use `NativeFloatTokens.Color` for the 2 custom values.
3. **No Liquid Glass** — Do not use `.glassEffect()`, `GlassEffectContainer`, or `.buttonStyle(.glass)`.
4. **SPM build** — No Xcode project. Build via `./build.sh`.
5. **HoverToggles are sacred** — Three separate `.primaryAction` items. Never combine.
6. **WindowAccessor takes primitives** — Never pass `@Bindable` or `@Observable`.
7. **Showcase pages are non-functional** — Visual reference only. No real data.
8. **Springs only** — Two springs: `NativeFloatTokens.Motion.selection` and `.layout`.

## Build

```bash
cd NativeFloatDemo && ./build.sh
open NativeFloatDemo.app
```

## Structure

- `Design/` — NativeFloatTokens.swift + WindowAccessor.swift
- `Models/` — AppSettings.swift
- `Sidebar/` — DemoSidebarView + SidebarSearchField
- `Components/` — Reusable: SettingsCard, DemoCard, DragPreviewCapsule
- `Showcases/` — 12 pages demonstrating different aspects
