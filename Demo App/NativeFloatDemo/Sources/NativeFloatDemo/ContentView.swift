import SwiftUI

enum Showcase: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case hoverToggles = "HoverToggles"
    case sidebar = "Sidebar"
    case typography = "Typography"
    case colors = "Colors"
    case materials = "Materials"
    case components = "Components"
    case animation = "Animation"
    case layout = "Layout"
    case windowManagement = "Window Management"
    case nativePatterns = "Native Patterns"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .overview: "square.grid.2x2"
        case .hoverToggles: "slider.horizontal.3"
        case .sidebar: "sidebar.left"
        case .typography: "textformat"
        case .colors: "paintpalette"
        case .materials: "square.on.square"
        case .components: "square.stack.3d.up"
        case .animation: "wand.and.stars"
        case .layout: "rectangle.split.3x1"
        case .windowManagement: "macwindow"
        case .nativePatterns: "apple.logo"
        case .settings: "gearshape"
        }
    }

    var section: ShowcaseSection {
        switch self {
        case .overview: .start
        case .hoverToggles, .sidebar: .identity
        case .typography, .colors, .materials: .styles
        case .components, .animation: .components
        case .layout, .windowManagement, .nativePatterns: .patterns
        case .settings: .reference
        }
    }
}

enum ShowcaseSection: String, CaseIterable {
    case start = "START"
    case identity = "IDENTITY"
    case styles = "STYLES"
    case components = "COMPONENTS"
    case patterns = "PATTERNS"
    case reference = "REFERENCE"
}

struct ContentView: View {
    @Bindable var settings: AppSettings

    @State private var selectedShowcase: Showcase? = .overview
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var showOpacityPopover = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            DemoSidebarView(selection: $selectedShowcase)
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            detailContent
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Spacer()
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { toggleAppearance() }) {
                            Image(systemName: colorScheme == .dark ? "sun.max" : "moon")
                        }
                        .help("Toggle appearance (\u{21E7}\u{2318}D)")
                        .keyboardShortcut("d", modifiers: [.shift, .command])
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showOpacityPopover = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: opacityIcon)
                                Text("\(Int(settings.windowOpacity * 100))%")
                                    .font(.caption)
                                    .monospacedDigit()
                            }
                        }
                        .popover(isPresented: $showOpacityPopover, arrowEdge: .bottom) {
                            OpacityPopoverContent(opacity: $settings.windowOpacity)
                        }
                        .help("Window opacity")
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Toggle(isOn: Bindable(settings).windowPinned) {
                            Image(systemName: "pin")
                        }
                        .toggleStyle(.button)
                        .help("Pin window (\u{2318}P)")
                        .keyboardShortcut("p", modifiers: .command)
                    }
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

    @ViewBuilder
    private var detailContent: some View {
        switch selectedShowcase {
        case .overview: OverviewShowcase()
        case .hoverToggles: HoverTogglesShowcase(settings: settings)
        case .sidebar: SidebarShowcase()
        case .typography: TypographyShowcase()
        case .colors: ColorsShowcase()
        case .materials: MaterialsShowcase()
        case .components: ComponentsShowcase()
        case .animation: AnimationShowcase()
        case .layout: LayoutShowcase()
        case .windowManagement: WindowManagementShowcase(settings: settings)
        case .nativePatterns: NativePatternsShowcase()
        case .settings: SettingsShowcase(settings: settings)
        case .none: OverviewShowcase()
        }
    }

    private var opacityIcon: String {
        if settings.windowOpacity >= 0.95 { return "circle.fill" }
        if settings.windowOpacity >= 0.60 { return "circle.lefthalf.filled" }
        return "circle.dotted"
    }

    private func toggleAppearance() {
        settings.appearance = settings.appearance == "dark" ? "light" : "dark"
    }
}

struct OpacityPopoverContent: View {
    @Binding var opacity: Double
    private let presets: [Double] = [0.25, 0.35, 0.50, 0.70, 0.85, 1.00]

    var body: some View {
        VStack(spacing: 12) {
            Slider(value: $opacity, in: 0.25...1.0)

            HStack(spacing: 8) {
                ForEach(presets, id: \.self) { preset in
                    Button("\(Int(preset * 100))%") {
                        withAnimation(.easeOut(duration: 0.15)) {
                            opacity = preset
                        }
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(
                            opacity == preset
                                ? Color.accentColor.opacity(0.2)
                                : Color(nsColor: .controlBackgroundColor)
                        )
                    )
                    .foregroundStyle(opacity == preset ? Color.accentColor : .primary)
                }
            }
        }
        .padding(16)
        .frame(width: 300)
    }
}
