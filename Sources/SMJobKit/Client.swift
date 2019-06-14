//
//  Client.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation
import ServiceManagement

open class Client {

	// MARK: - Abstract Interface

	open class var serviceIdentifier: String {
		fatalError("You need to implement serviceIdentifier!")
	}

	// MARK: - Public Interface

	public class var bundledVersion: String? {
		return try? ClientUtility.versionForBundlePath(bundledServicePath)
	}

	public class func installWithPrompt(prompt: String?) throws {
		let authRef = try ClientUtility.authWithRight(kSMRightBlessPrivilegedHelper, prompt: prompt)

		// Here's the good stuff
		var cfError: Unmanaged<CFError>?
		if !SMJobBless(kSMDomainSystemLaunchd, cfIdentifier, authRef, &cfError) {
			let blessError = cfError!.takeRetainedValue()
			throw SMJError.unableToBless(blessError) // String(format: "SMJobBless failure (code %ld): %@", blessError.code, blessError.localizedDescription)
		}

		NSLog("%@ (%@) installed successfully", serviceIdentifier as NSString, bundledVersion! as NSString)
	}

	// MARK: - Diagnostics

	public class func checkForProblems() -> [Error] {
		var errors = [Error]()

		do {
			try _ = ClientUtility.versionForBundlePath(bundledServicePath)
		} catch let error {
			errors.append(error)
		}

		return errors
	}

	// MARK: - Service Information

	public class var bundledServicePath: String {
		let helperRelative = "Contents/Library/LaunchServices/\(serviceIdentifier)"

		return (Bundle(for: self).bundlePath as NSString).appendingPathComponent(helperRelative)
	}

	// MARK: - Utility

	private class var cfIdentifier: CFString {
		return serviceIdentifier as CFString
	}

}
