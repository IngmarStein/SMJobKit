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

class SMJClientTests: XCTestCase {

	func testBundledVersion() {
		XCTAssert(SMJTestClient.bundledVersion! == "0.01", "Missing/wrong version")
		XCTAssert(SMJMissingClient.bundledVersion == nil, "Missing client should return nil")
	}

	func testInstalledVersion() {
		XCTAssert(SMJTestClient.installedVersion == nil, "Missing client should return nil")
	}

	func testForProblems() {
		XCTAssertNil(SMJTestClient.checkForProblems(), "TestService should not have problems")

		let errors = SMJMissingClient.checkForProblems()
		XCTAssertNotNil(errors, "MissingService should have errors")
		XCTAssertEqual(errors!.count, 1, "MissingService should have one error")
		let error = errors!.first
		XCTAssert(SMJErrorCode(rawValue:error!.code) == .BundleNotFound, "Missing service should be missing")
	}

}
