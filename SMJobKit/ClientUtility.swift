//
//  SMJClientUtility.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation
import Security

class ClientUtility {

	//MARK -   Bundle Introspection

	class func versionForBundlePath(bundlePath: String) -> String? {
		return versionForBundlePath(bundlePath, error:nil)
	}

	class func versionForBundlePath(bundlePath: String, error:NSErrorPointer) -> String? {
		// We can't use CFBundleCopyInfoDictionaryForURL, as it breaks our code signing validity.
		var codeRef: Unmanaged<SecStaticCode>? = nil

		if let url = NSURL(fileURLWithPath: bundlePath, isDirectory: false) {
			let result = SecStaticCodeCreateWithPath(url, SecCSFlags(kSecCSDefaultFlags), &codeRef)
			if result == noErr, let code = codeRef?.takeRetainedValue() {
				var codeInfoRef: Unmanaged<CFDictionary>? = nil
				let result2 = SecCodeCopySigningInformation(code, SecCSFlags(kSecCSDefaultFlags), &codeInfoRef)
				if result2 == noErr, let codeInfo = codeInfoRef?.takeRetainedValue() {
					if let codeInfoDictionary = codeInfo as? [NSObject: AnyObject], bundleInfo = codeInfoDictionary[kSecCodeInfoPList] as? [NSObject: AnyObject] {
						return bundleInfo["CFBundleVersion"] as? String
					} else {
						SET_ERROR(error, .BadBundleCodeSigningDictionary, "kSecCodeInfoPList was not a dictionary")
						return nil
					}
				} else {
					SET_ERROR(error, .BadBundleCodeSigningDictionary, "Failed to read code signing dictionary (OSStatus %d)", result2)
					return nil
				}
			} else {
				if result == OSStatus(errSecCSUnsigned) {
					SET_ERROR(error, .UnsignedBundle, "Encountered unsigned bundle")
				} else if result == OSStatus(errSecCSStaticCodeNotFound) {
					SET_ERROR(error, .BundleNotFound, "No bundle found at given path")
				} else {
					SET_ERROR(error, .BadBundleSecurity, "Failed to create SecStaticCodeRef (OSStatus %d)", result)
				}
				return nil
			}
		} else {
			return nil
		}
	}

	//MARK: - Authorization & Security

	class func authWithRight(rightName: AuthorizationString, prompt:String?, error:NSErrorPointer) -> AuthorizationRef {
		var authItem = AuthorizationItem(name: rightName, valueLength: 0, value: nil, flags: 0)
		var authRights = AuthorizationRights(count: 1, items: &authItem)

		var environment = AuthorizationEnvironment(count: 0, items: nil)

		if let prompt = prompt {
			let authorizationEnvironmentPrompt = (kAuthorizationEnvironmentPrompt as NSString).UTF8String
			let promptString = (prompt as NSString).UTF8String
			var envItem = AuthorizationItem(name: authorizationEnvironmentPrompt, valueLength: prompt.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), value: UnsafeMutablePointer(promptString), flags: UInt32(0))
			environment = AuthorizationEnvironment(count: 1, items: &envItem)
		}

		let flags = AuthorizationFlags(kAuthorizationFlagDefaults
			| kAuthorizationFlagInteractionAllowed
			| kAuthorizationFlagPreAuthorize
			| kAuthorizationFlagExtendRights)

		var authRef: AuthorizationRef = nil
		let status = AuthorizationCreate(&authRights, &environment, flags, &authRef)
		if status == OSStatus(errAuthorizationSuccess) {
			return authRef
		} else if status == OSStatus(errAuthorizationDenied) {
			SET_ERROR(error, .AuthorizationDenied, "The system denied the authorization request")
		} else if status == OSStatus(errAuthorizationCanceled) {
			SET_ERROR(error, .AuthorizationCanceled, "The user canceled the authorization request")
		} else if status == OSStatus(errAuthorizationInteractionNotAllowed) {
			SET_ERROR(error, .AuthorizationInteractionNotAllowed, "Not allowed to prompt the user for authorization")
		} else {
			SET_ERROR(error, .AuthorizationFailed, "Unknown failure when calling AuthorizationCreate (OSStatus %d)", status)
		}
  
		return nil
	}
}
