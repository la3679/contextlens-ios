import ContextLensCore
import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section {
                Label(ProcessingMode.defaultMode.title, systemImage: "iphone")
                    .accessibilityIdentifier("settings.processingMode")
                Text("Your content stays on this device. Nothing is sent to a cloud AI provider.")
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("settings.privacyExplanation")
            } header: {
                Text("AI processing")
            }
            Section("About") {
                LabeledContent("ContextLens", value: "0.1.0")
                Text("Capture understanding. Keep control.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
