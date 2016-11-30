//
//  ClientUtility.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation
import Security

final class ClientUtility {

	// MARK: - Bundle Introspection

	static func versionForBundlePath(_ bundlePath: String) throws -> String {
		// We can't use CFBundleCopyInfoDictionaryForURL, as it breaks our code signing validity.
		var codeRef: SecStaticCode?

		let url = NSURL(fileURLWithPath: bundlePath, isDirectory: false)
		let result = SecStaticCodeCreateWithPath(url, [], &codeRef)
		if result == noErr, let code = codeRef {
			var codeInfoRef: CFDictionary?
			let result2 = SecCodeCopySigningInformation(code, [], &codeInfoRef)
			if result2 == noErr, let codeInfo = codeInfoRef {
				let codeInfoDictionary = codeInfo as [NSObject: AnyObject]
				if let bundleInfo = codeInfoDictionary[kSecCodeInfoPList] as? [String: AnyObject] {
					if let value = bundleInfo["CFBundleVersion"] as? String {
						return value
					} else {
						throw SMJError.badBundleCodeSigningDictionary // "CFBundleVersion was not a string"
					}
				} else {
					throw SMJError.badBundleCodeSigningDictionary // "kSecCodeInfoPList was not a dictionary"
				}
			} else {
				throw SMJError.badBundleCodeSigningDictionary // String(format: "Failed to read code signing dictionary (OSStatus %d)", result2)
			}
		} else {
			if result == OSStatus(errSecCSUnsigned) {
				throw SMJError.unsignedBundle // "Encountered unsigned bundle"
			} else if result == OSStatus(errSecCSStaticCodeNotFound) {
				throw SMJError.bundleNotFound // "No bundle found at given path"
			} else {
				throw SMJError.badBundleSecurity(result) // String(format: "Failed to create SecStaticCodeRef (OSStatus %d)", result)
			}
		}
	}

	// MARK: - Authorization & Security

	static func authWithRight(_ rightName: String, prompt: String?) throws -> AuthorizationRef {
		let authorizationRight = (rightName as NSString).utf8String!
		var authItem = AuthorizationItem(name: authorizationRight, valueLength: 0, value: nil, flags: 0)
		var authRights = AuthorizationRights(count: 1, items: &authItem)

		var environment = AuthorizationEnvironment(count: 0, items: nil)

		if let prompt = prompt {
			let authorizationEnvironmentPrompt = (kAuthorizationEnvironmentPrompt as NSString).utf8String!
			let promptString = (prompt as NSString).utf8String!
			var envItem = AuthorizationItem(name: authorizationEnvironmentPrompt, valueLength: prompt.lengthOfBytes(using: String.Encoding.utf8), value: UnsafeMutablePointer(mutating: promptString), flags: UInt32(0))
			environment = AuthorizationEnvironment(count: 1, items: &envItem)
		}

		let flags: AuthorizationFlags = [
			.interactionAllowed,
			.preAuthorize,
			.extendRights
		]

		var authRef: AuthorizationRef? = nil
		let status = AuthorizationCreate(&authRights, &environment, flags, &authRef)
		if status == OSStatus(errAuthorizationSuccess) {
			return authRef!
		} else if status == OSStatus(errAuthorizationDenied) {
			throw SMJError.authorizationDenied // "The system denied the authorization request"
		} else if status == OSStatus(errAuthorizationCanceled) {
			throw SMJError.authorizationCanceled // "The user canceled the authorization request"
		} else if status == OSStatus(errAuthorizationInteractionNotAllowed) {
			throw SMJError.authorizationInteractionNotAllowed // "Not allowed to prompt the user for authorization"
		} else {
			throw SMJError.authorizationFailed(status) // String(format: "Unknown failure when calling AuthorizationCreate (OSStatus %d)", status)
		}
	}

}
