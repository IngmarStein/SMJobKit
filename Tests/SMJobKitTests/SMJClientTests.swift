//
//  SMJClientTests.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Cocoa
import XCTest
import SMJobKit

class ClientTests: XCTestCase {

	func testBundledVersion() {
		XCTAssert(TestClient.bundledVersion! == "0.01", "Missing/wrong version")
		XCTAssert(MissingClient.bundledVersion == nil, "Missing client should return nil")
	}

	func testInstalledVersion() {
		XCTAssert(TestClient.installedVersion == nil, "Missing client should return nil")
	}

	func testForProblems() {
		XCTAssertNil(TestClient.checkForProblems(), "TestService should not have problems")

		let errors = MissingClient.checkForProblems()
		XCTAssertNotNil(errors, "MissingService should have errors")
		XCTAssertEqual(errors!.count, 1, "MissingService should have one error")
		let error = errors!.first
		XCTAssert(ErrorCode(rawValue:error!.code) == .BundleNotFound, "Missing service should be missing")
	}

}
