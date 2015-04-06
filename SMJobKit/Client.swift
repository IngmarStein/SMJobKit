//
//  SMJClient.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Cocoa
import ServiceManagement

public class Client {

	//MARK: - Abstract Interface

	public class var serviceIdentifier: String {
		fatalError("You need to implement serviceIdentifier!")
	}

	//MARK: - Public Interface

	public class var bundledVersion: String? {
		return ClientUtility.versionForBundlePath(bundledServicePath)
	}

	public class func installWithPrompt(prompt:String?, error:NSErrorPointer) -> Bool {
		let authRef = ClientUtility.authWithRight(kSMRightBlessPrivilegedHelper, prompt:prompt, error:error)
		if authRef == nil {
			return false
		}
  
		// Here's the good stuff
		var cfError: Unmanaged<CFError>? = nil
		if SMJobBless(kSMDomainSystemLaunchd, cfIdentifier, authRef, &cfError) == 0 {
			let blessError = cfError!.takeRetainedValue() as AnyObject as! NSError
			SET_ERROR(error, .UnableToBless, "SMJobBless failure (code %ld): %@", blessError.code, blessError.localizedDescription)
			return false
		}
  
		NSLog("%@ (%@) installed successfully", serviceIdentifier, bundledVersion!)
		return true
	}

	//MARK: - Diagnostics

	public class func checkForProblems() -> [NSError] {
		var error: NSError? = nil
		var errors = [NSError]()
  
		ClientUtility.versionForBundlePath(bundledServicePath, error:&error)
		if error != nil {
			errors.append(error!)
		}
  
		return errors
	}

	//MARK: - Service Information

	public class var bundledServicePath: String {
		let helperRelative = "Contents/Library/LaunchServices/\(serviceIdentifier)"
  
		return NSBundle(forClass:self).bundlePath.stringByAppendingPathComponent(helperRelative)
	}

	//MARK: - Utility

	private class var cfIdentifier: CFString {
		return serviceIdentifier as CFString
	}

}
