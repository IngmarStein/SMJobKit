//
//  Client.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation
import ServiceManagement

public class Client {

	// MARK: - Abstract Interface

	public class var serviceIdentifier: String {
		fatalError("You need to implement serviceIdentifier!")
	}

	// MARK: - Public Interface

	public class var bundledVersion: String? {
		return try? ClientUtility.versionForBundlePath(bundledServicePath)
	}

	#if swift(>=3.0)

	public class func installWithPrompt(prompt: String?) throws {
		let authRef = try ClientUtility.authWithRight(kSMRightBlessPrivilegedHelper, prompt:prompt)

		// Here's the good stuff
		var cfError: Unmanaged<CFError>? = nil
		if !SMJobBless(kSMDomainSystemLaunchd, cfIdentifier, authRef, &cfError) {
			let blessError = cfError!.takeRetainedValue() as NSError
			throw SMJError.unableToBless(blessError) // String(format: "SMJobBless failure (code %ld): %@", blessError.code, blessError.localizedDescription)
		}
  
		NSLog("%@ (%@) installed successfully", serviceIdentifier, bundledVersion!)
	}

	// MARK: - Diagnostics

	public class func checkForProblems() -> [ErrorProtocol] {
		var errors = [ErrorProtocol]()
  
		do {
			try ClientUtility.versionForBundlePath(bundledServicePath)
		} catch let error {
			errors.append(error)
		}
  
		return errors
	}

	// MARK: - Service Information

	public class var bundledServicePath: String {
		let helperRelative = "Contents/Library/LaunchServices/\(serviceIdentifier)"

		return (NSBundle(for:self).bundlePath as NSString).appendingPathComponent(helperRelative)
	}

	#else

	public class func installWithPrompt(prompt: String?) throws {
		let authRef = try ClientUtility.authWithRight(kSMRightBlessPrivilegedHelper, prompt: prompt)

		// Here's the good stuff
		var cfError: Unmanaged<CFError>? = nil
		if !SMJobBless(kSMDomainSystemLaunchd, cfIdentifier, authRef, &cfError) {
			let blessError = cfError!.takeRetainedValue() as NSError
			throw SMJError.UnableToBless(blessError) // String(format: "SMJobBless failure (code %ld): %@", blessError.code, blessError.localizedDescription)
		}
  
		NSLog("%@ (%@) installed successfully", serviceIdentifier, bundledVersion!)
	}

	// MARK: - Diagnostics

	public class func checkForProblems() -> [ErrorType] {
		var errors = [ErrorType]()
  
		do {
			try ClientUtility.versionForBundlePath(bundledServicePath)
		} catch let error {
			errors.append(error)
		}
  
		return errors
	}

	// MARK: - Service Information

	public class var bundledServicePath: String {
		let helperRelative = "Contents/Library/LaunchServices/\(serviceIdentifier)"
  
		return (NSBundle(forClass:self).bundlePath as NSString).stringByAppendingPathComponent(helperRelative)
	}

	#endif

	// MARK: - Utility

	private class var cfIdentifier: CFString {
		return serviceIdentifier as CFString
	}

}
