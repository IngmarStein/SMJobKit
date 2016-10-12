//
//  ErrorTypes.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation

#if swift(>=3.0)

public enum SMJError: Error {
	// A failure when referencing a bundle that doesn't exist (or bad perms)
	case bundleNotFound
	// A failure when trying to get the SecStaticCode for a bundle, but it is unsigned
	case unsignedBundle
	// Unknown failure when calling SecStaticCodeCreateWithPath
	case badBundleSecurity(OSStatus)
	// Unknown failure when calling SecCodeCopySigningInformation for a bundle
	case badBundleCodeSigningDictionary

	// Failure when calling SMJobBless
	case unableToBless(Error)

	// Authorization was denied by the system when asking a user for authorization
	case authorizationDenied
	// The user canceled a prompt for authorization
	case authorizationCanceled
	// Unable to prompt the user (interaction disallowed)
	case authorizationInteractionNotAllowed
	// Unknown failure when prompting the user for authorization
	case authorizationFailed(OSStatus)

	public var code: Int {
		switch self {
		case .bundleNotFound: return 1000
		case .unsignedBundle: return 1001
		case .badBundleSecurity(_): return 1002
		case .badBundleCodeSigningDictionary: return 1003
		case .unableToBless(_): return 1010
		case .authorizationDenied: return 1020
		case .authorizationCanceled: return 1021
		case .authorizationInteractionNotAllowed: return 1022
		case .authorizationFailed(_): return 1023
		}
	}
}

#else

public enum SMJError: ErrorType {
	// A failure when referencing a bundle that doesn't exist (or bad perms)
	case BundleNotFound
	// A failure when trying to get the SecStaticCode for a bundle, but it is unsigned
	case UnsignedBundle
	// Unknown failure when calling SecStaticCodeCreateWithPath
	case BadBundleSecurity(OSStatus)
	// Unknown failure when calling SecCodeCopySigningInformation for a bundle
	case BadBundleCodeSigningDictionary

	// Failure when calling SMJobBless
	case UnableToBless(NSError)

	// Authorization was denied by the system when asking a user for authorization
	case AuthorizationDenied
	// The user canceled a prompt for authorization
	case AuthorizationCanceled
	// Unable to prompt the user (interaction disallowed)
	case AuthorizationInteractionNotAllowed
	// Unknown failure when prompting the user for authorization
	case AuthorizationFailed(OSStatus)

	public var code: Int {
		switch self {
		case .BundleNotFound: return 1000
		case .UnsignedBundle: return 1001
		case .BadBundleSecurity(_): return 1002
		case .BadBundleCodeSigningDictionary: return 1003
		case .UnableToBless(_): return 1010
		case .AuthorizationDenied: return 1020
		case .AuthorizationCanceled: return 1021
		case .AuthorizationInteractionNotAllowed: return 1022
		case .AuthorizationFailed(_): return 1023
		}
	}
}

#endif
