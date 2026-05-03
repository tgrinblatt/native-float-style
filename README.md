# Native Float

A macOS Tahoe+ style reference for building Apple-native SwiftUI apps with the HoverToggle personality.

System fonts. Native materials. Tahoe auto-glass toolbar. The identity comes from two core marks: the **HoverToggles cluster** (appearance/opacity/pin) and the **frosted sidebar treatment** (traffic lights on ultraThinMaterial, capsule search, inline title row with gear).

## How It Differs from tyler-app-style

| | tyler-app-style | Native Float |
|---|---|---|
| Fonts | Geist (bundled) | System fonts only |
| Colors | 20+ custom hex | System + 2 custom values |
| Glass | Explicit `.glassEffect()` | Tahoe auto-glass on toolbar only |
| Accent | #E5600A orange | System accent (user's choice) |
| Identity | Liquid Glass + orange | HoverToggles + frosted sidebar |

## Install as Claude Skill

```bash
claude plugin install /path/to/native-float-style
```

## Run the Demo

```bash
cd "Demo App/NativeFloatDemo"
./build.sh
open NativeFloatDemo.app
```

## Branch Strategy

- `main` — Skill plugin (what gets installed)
- `style-demo` — Demo app + full project (visual reference)

## Core Design Marks

### HoverToggles Cluster
Three separate `ToolbarItem(.primaryAction)` items that Tahoe groups visually:
- **Appearance** — light/dark binary toggle (icon reflects state)
- **Opacity** — button + popover with slider and 6 presets
- **Pin** — `Toggle(.button)` for native blue accent when active

### Frosted Sidebar
- `NavigationSplitView(.balanced)` with `.ultraThinMaterial`
- Traffic lights sit on the translucent sidebar (Apple Notes pattern)
- Title row with app name + gear, inline with traffic lights
- Capsule search field with `.controlBackgroundColor`
- Section headers in uppercase `.caption`

### WindowAccessor Bridge
- NSViewRepresentable taking primitive values
- Reactive pin/float, opacity, show-on-all-desktops, hide-on-close
