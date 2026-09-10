import SwiftUI

@main
struct ContextLensApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modifier(PreviewEnvironment())
        }
    }
}

/// Deterministic visual test configuration is excluded from release builds.
private struct PreviewEnvironment: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        content
            .preferredColorScheme(arguments.contains("-ui-dark") ? .dark : nil)
            .environment(\.dynamicTypeSize, arguments.contains("-ui-large-text") ? .accessibility3 : dynamicTypeSize)
        #else
        content
        #endif
    }
}
