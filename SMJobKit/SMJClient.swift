//
//  SMJClient.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Cocoa
import ServiceManagement

public class SMJClient: NSObject {

	//MARK: - Abstract Interface

	public class var serviceIdentifier: String {
		fatalError("You need to implement serviceIdentifier!")
	}

	//MARK: - Public Interface

	public class var bundledVersion: String? {
		return SMJClientUtility.versionForBundlePath(bundledServicePath)
	}

	public class var installedVersion: String? {
		return installedServicePath.flatMap { SMJClientUtility.versionForBundlePath($0) }
	}

	public class func isLatestVersionInstalled() -> Bool {
		if let installedVersion = installedVersion, bundledVersion = bundledVersion {
			return installedVersion == bundledVersion
		}
		return false
	}

	public class func installWithPrompt(prompt:String?, error:NSErrorPointer) -> Bool {
		if isLatestVersionInstalled() {
			NSLog("%@ (%@) is already current, skipping install.", serviceIdentifier, bundledVersion!)
			return true
		}
  
		if installedVersion != nil {
			if !uninstallWithPrompt(prompt, error:error) {
				return false
			}
		}
  
		let authRef = SMJClientUtility.authWithRight(kSMRightBlessPrivilegedHelper, prompt:prompt, error:error)
		if authRef == nil {
			return false
		}
  
		// Here's the good stuff
		var cfError: Unmanaged<CFError>? = nil
		if SMJobBless(kSMDomainSystemLaunchd, cfIdentifier, authRef, &cfError) == 0 {
			let blessError = cfError!.takeRetainedValue() as AnyObject as! NSError
			SET_ERROR(error, .UnableToBless, "SMJobBless Failure (code %ld): %@", blessError.code, blessError.localizedDescription)
			return false
		}
  
		NSLog("%@ (%@) installed successfully", serviceIdentifier, bundledVersion!)
		return true
	}

	public class func uninstallWithPrompt(prompt : String?, error:NSErrorPointer) -> Bool {
		if installedVersion == nil {
			NSLog("%@ is not installed, skipping uninstall.", serviceIdentifier)
			return true
		}
  
		let authRef = SMJClientUtility.authWithRight(kSMRightModifySystemDaemons, prompt:prompt, error:error)
		if authRef == nil {
			return false
		}
  
		var cfError: Unmanaged<CFError>? = nil
		if SMJobRemove(kSMDomainSystemLaunchd, cfIdentifier, authRef, 1, &cfError) == 0 {
			let removeError = cfError!.takeRetainedValue() as AnyObject as! NSError
			SET_ERROR(error, .UnableToBless, "SMJobRemove Failure (code %ld): %@", removeError.code, removeError.localizedDescription)
			return false
		}
  
		NSLog("%@ uninstalled successfully", serviceIdentifier)
		return true
	}


	//MARK: - Diagnostics

	public class func checkForProblems() -> [NSError]? {
		var error: NSError? = nil
		var errors = [NSError]()
  
		SMJClientUtility.versionForBundlePath(bundledServicePath, error:&error)
		if error != nil {
			errors.append(error!)
		}
  
		return errors.isEmpty ? nil : errors
	}


	//MARK: - Service Information

	public class var bundledServicePath: String {
		let helperRelative = "Contents/Library/LaunchServices/\(serviceIdentifier)"
  
		return NSBundle(forClass:self).bundlePath.stringByAppendingPathComponent(helperRelative)
	}

	public class var installedServicePath: String? {
		if let jobData = SMJobCopyDictionary(kSMDomainSystemLaunchd, self.cfIdentifier) {
			if let dictionary = jobData.takeRetainedValue() as? [NSObject:AnyObject] {
				if let arguments = dictionary["ProgramArguments"] as? [String] {
					return arguments.first
				}
			}
		}
		return nil
	}

	//MARK: - Utility

	private class var cfIdentifier: CFString {
		return serviceIdentifier as CFString
	}

}
