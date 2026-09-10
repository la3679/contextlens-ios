/// A privacy policy, independent of whether a provider happens to be available.
public enum ProcessingMode: String, CaseIterable, Codable, Sendable {
    case onDeviceOnly
    case onDevicePreferred
    case cloudAllowed

    public static let defaultMode: Self = .onDeviceOnly

    /// Availability or failure of a local provider never grants cloud consent.
    /// Preferred mode can choose among local capabilities but cannot upload content.
    public var permitsCloudTransmission: Bool {
        self == .cloudAllowed
    }

    public var title: String {
        switch self {
        case .onDeviceOnly: "On-device only"
        case .onDevicePreferred: "On-device preferred"
        case .cloudAllowed: "Cloud allowed"
        }
    }
}
