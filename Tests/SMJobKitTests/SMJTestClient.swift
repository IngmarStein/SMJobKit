//
//  SMJTestClient.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import SMJobKit

class TestClient: Client {
	override class var serviceIdentifier: String {
		return "net.nevir.SMJobKitTests.TestService"
	}
}
