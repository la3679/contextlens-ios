import ContextLensCore
import XCTest
@testable import ContextLens

final class ApplicationBoundaryTests: XCTestCase {
    func testAppBundleContainsNoBackendEnvironmentFile() throws {
        let resourceURL = try XCTUnwrap(Bundle.main.resourceURL)
        let files = try FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil)
        XCTAssertFalse(files.contains { $0.lastPathComponent.hasPrefix(".env") })
    }

    func testFoundationStartsWithCloudDisabled() {
        XCTAssertEqual(ProcessingMode.defaultMode, .onDeviceOnly)
        XCTAssertFalse(ProcessingMode.defaultMode.permitsCloudTransmission)
    }
}
