//
//  SMJErrorTypes.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation

public enum ErrorCode: Int {
	// A failure when referencing a bundle that doesn't exist (or bad perms)
	case BundleNotFound = 1000
	// A failure when trying to get the SecStaticCode for a bundle, but it is unsigned
	case UnsignedBundle = 1001
	// Unknown failure when calling SecStaticCodeCreateWithPath
	case BadBundleSecurity = 1002
	// Unknown failure when calling SecCodeCopySigningInformation for a bundle
	case BadBundleCodeSigningDictionary = 1003

	// Failure when calling SMJobBless
	case UnableToBless = 1010

	// Authorization was denied by the system when asking a user for authorization
	case AuthorizationDenied = 1020
	// The user canceled a prompt for authorization
	case AuthorizationCanceled = 1021
	// Unable to prompt the user (interaction disallowed)
	case AuthorizationInteractionNotAllowed = 1022
	// Unknown failure when prompting the user for authorization
	case AuthorizationFailed = 1023

}
