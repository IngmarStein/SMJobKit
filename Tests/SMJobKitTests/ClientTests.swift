//
//  ClientTests.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Cocoa
import XCTest
@testable import SMJobKit

class ClientTests: XCTestCase {

	func testBundledVersion() {
		XCTAssert(TestClient.bundledVersion! == "0.01", "Missing/wrong version")
		XCTAssert(MissingClient.bundledVersion == nil, "Missing client should return nil")
	}

	func testForProblems() {
		XCTAssert(TestClient.checkForProblems().isEmpty, "TestService should not have problems")

		let errors = MissingClient.checkForProblems()
		XCTAssertEqual(errors.count, 1, "MissingService should have one error")
		let error = errors.first! as! SMJError
		switch error {
		case .BundleNotFound: ()
		default:
			XCTAssert(false, "Missing service should be missing")
		}
	}

}
