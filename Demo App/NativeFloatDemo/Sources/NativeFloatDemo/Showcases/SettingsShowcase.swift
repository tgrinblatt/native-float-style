import SwiftUI

struct SettingsShowcase: View {
    @Bindable var settings: AppSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("In-canvas settings via SettingsCard components. Accessed via gear in sidebar title row.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(spacing: NativeFloatTokens.Spacing.lg) {
                    SettingsCard(title: "Appearance") {
                        Picker("Mode", selection: $settings.appearance) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(.segmented)
                    }

                    SettingsCard(title: "Window") {
                        VStack(alignment: .leading, spacing: 12) {
                            Toggle("Pin on launch", isOn: .constant(false))
                            Toggle("Show on all desktops", isOn: $settings.showOnAllDesktops)

                            Divider()

                            HStack {
                                Text("Default opacity")
                                Spacer()
                                Text("\(Int(settings.windowOpacity * 100))%")
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $settings.windowOpacity, in: 0.25...1.0)
                        }
                    }

                    SettingsCard(title: "General") {
                        Toggle("Launch at login", isOn: .constant(false))
                        Toggle("Hide on close (\u{2318}W)", isOn: .constant(true))
                    }

                    SettingsCard(title: "About") {
                        VStack(alignment: .leading, spacing: 8) {
                            LabeledContent("App", value: "Native Float Demo")
                            LabeledContent("Version", value: "1.0.0")
                            LabeledContent("Platform", value: "macOS 26+ (Tahoe)")
                            LabeledContent("Style", value: "Native Float")
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
            .frame(maxWidth: 500)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
    }
}
