//
//  SampleService.swift
//  SampleApplication
//
//  Created by Ingmar Stein on 29.03.15.
//  Copyright (c) 2015 Ian MacLeod. All rights reserved.
//

import Cocoa
import SMJobKit

class SampleService: SMJClient {
	override class var serviceIdentifier: String {
		return "net.nevir.SMJobKit.SampleApplication.SampleService"
	}
}
