//
//  SMJMissingClient.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import SMJobKit

class SMJMissingClient: SMJClient {

	override class var serviceIdentifier: String {
		return "net.nevir.SMJobKitTests.MissingService"
	}

}
