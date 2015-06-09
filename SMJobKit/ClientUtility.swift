//
//  SMJClientUtility.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation
import Security

final class ClientUtility {

	//MARK: - Bundle Introspection

	static func versionForBundlePath(bundlePath: String) throws -> String {
		// We can't use CFBundleCopyInfoDictionaryForURL, as it breaks our code signing validity.
		var codeRef: Unmanaged<SecStaticCode>? = nil

		let url = NSURL(fileURLWithPath: bundlePath, isDirectory: false)
		let result = SecStaticCodeCreateWithPath(url, SecCSFlags(kSecCSDefaultFlags), &codeRef)
		if result == noErr, let code = codeRef?.takeRetainedValue() {
			var codeInfoRef: Unmanaged<CFDictionary>? = nil
			let result2 = SecCodeCopySigningInformation(code, SecCSFlags(kSecCSDefaultFlags), &codeInfoRef)
			if result2 == noErr, let codeInfo = codeInfoRef?.takeRetainedValue() {
				let codeInfoDictionary = codeInfo as [NSObject: AnyObject]
				if let bundleInfo = codeInfoDictionary[kSecCodeInfoPList] as? [NSObject: AnyObject] {
					if let value = bundleInfo["CFBundleVersion"] as? String {
						return value
					} else {
						throw NSError(code:.BadBundleCodeSigningDictionary, message:"CFBundleVersion was not a string")
					}
				} else {
					throw NSError(code:.BadBundleCodeSigningDictionary, message:"kSecCodeInfoPList was not a dictionary")
				}
			} else {
				throw NSError(code:.BadBundleCodeSigningDictionary, message:String(format: "Failed to read code signing dictionary (OSStatus %d)", result2))
			}
		} else {
			if result == OSStatus(errSecCSUnsigned) {
				throw NSError(code:.UnsignedBundle, message:"Encountered unsigned bundle")
			} else if result == OSStatus(errSecCSStaticCodeNotFound) {
				throw NSError(code:.BundleNotFound, message:"No bundle found at given path")
			} else {
				throw NSError(code:.BadBundleSecurity, message:String(format: "Failed to create SecStaticCodeRef (OSStatus %d)", result))
			}
		}
	}

	//MARK: - Authorization & Security

	static func authWithRight(rightName: String, prompt:String?) throws -> AuthorizationRef {
		let authorizationRight = (rightName as NSString).UTF8String
		var authItem = AuthorizationItem(name: authorizationRight, valueLength: 0, value: nil, flags: 0)
		var authRights = AuthorizationRights(count: 1, items: &authItem)

		var environment = AuthorizationEnvironment(count: 0, items: nil)

		if let prompt = prompt {
			let authorizationEnvironmentPrompt = (kAuthorizationEnvironmentPrompt as NSString).UTF8String
			let promptString = (prompt as NSString).UTF8String
			var envItem = AuthorizationItem(name: authorizationEnvironmentPrompt, valueLength: prompt.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), value: UnsafeMutablePointer(promptString), flags: UInt32(0))
			environment = AuthorizationEnvironment(count: 1, items: &envItem)
		}

		let flags: AuthorizationFlags = [
			.Defaults,
			.InteractionAllowed,
			.PreAuthorize,
			.ExtendRights
		]

		var authRef: AuthorizationRef = nil
		let status = AuthorizationCreate(&authRights, &environment, flags, &authRef)
		if status == OSStatus(errAuthorizationSuccess) {
			return authRef
		} else if status == OSStatus(errAuthorizationDenied) {
			throw NSError(code:.AuthorizationDenied, message:"The system denied the authorization request")
		} else if status == OSStatus(errAuthorizationCanceled) {
			throw NSError(code:.AuthorizationCanceled, message:"The user canceled the authorization request")
		} else if status == OSStatus(errAuthorizationInteractionNotAllowed) {
			throw NSError(code:.AuthorizationInteractionNotAllowed, message:"Not allowed to prompt the user for authorization")
		} else {
			throw NSError(code:.AuthorizationFailed, message:String(format: "Unknown failure when calling AuthorizationCreate (OSStatus %d)", status))
		}
	}
}
