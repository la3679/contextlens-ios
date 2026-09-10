import Foundation
import XCTest
@testable import ContextLensCore

final class ProcessingModeTests: XCTestCase {
    func testDefaultProhibitsTransmission() {
        XCTAssertEqual(ProcessingMode.defaultMode, .onDeviceOnly)
        XCTAssertFalse(ProcessingMode.defaultMode.permitsCloudTransmission)
    }

    func testOnlyExplicitCloudPolicyPermitsTransmission() {
        XCTAssertFalse(ProcessingMode.onDevicePreferred.permitsCloudTransmission)
        XCTAssertTrue(ProcessingMode.cloudAllowed.permitsCloudTransmission)
    }

    func testPersistedModesRoundTrip() throws {
        for mode in ProcessingMode.allCases {
            let encoded = try JSONEncoder().encode(mode)
            XCTAssertEqual(try JSONDecoder().decode(ProcessingMode.self, from: encoded), mode)
        }
    }

    func testUnknownPersistedModeCannotGrantConsent() {
        let unknown = Data("\"futureCloudMode\"".utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(ProcessingMode.self, from: unknown))
    }
}
