import SwiftUI

struct WindowManagementShowcase: View {
    @Bindable var settings: AppSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Window Management")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("WindowAccessor bridges SwiftUI to NSWindow. These controls are live.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("LIVE CONTROLS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Pin / Float") {
                        Toggle("Window pinned (floats above all)", isOn: $settings.windowPinned)
                        Text("Sets window.level = .floating when on")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }

                    SettingsCard(title: "Opacity") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Window opacity")
                                Spacer()
                                Text("\(Int(settings.windowOpacity * 100))%")
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $settings.windowOpacity, in: 0.25...1.0)
                        }
                    }

                    SettingsCard(title: "Show on All Desktops") {
                        Toggle("Visible on all Spaces", isOn: $settings.showOnAllDesktops)
                        Text("Sets collectionBehavior = .canJoinAllSpaces")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("ARCHITECTURE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "WindowAccessor Pattern") {
                        VStack(alignment: .leading, spacing: 8) {
                            bulletPoint("NSViewRepresentable (invisible, no layout impact)")
                            bulletPoint("Takes PRIMITIVE values: Bool, Double")
                            bulletPoint("Never pass @Bindable or @Observable")
                            bulletPoint("Applied via .background(WindowAccessor(...))")
                            bulletPoint("updateNSView fires when struct properties differ")
                        }
                    }

                    SettingsCard(title: "HideOnCloseDelegate") {
                        VStack(alignment: .leading, spacing: 8) {
                            bulletPoint("Intercepts red close button / \u{2318}W")
                            bulletPoint("Calls window.orderOut(nil) instead of close")
                            bulletPoint("\u{2318}Q still quits (applicationShouldTerminate)")
                            bulletPoint("Forwards other delegate methods to SwiftUI's delegate")
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\u{2022}").foregroundStyle(.secondary)
            Text(text).font(.caption).foregroundStyle(.secondary)
        }
    }
}
