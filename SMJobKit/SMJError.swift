//
//  SMJError.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Cocoa

class SMJError : NSError {
	init(code:SMJErrorCode, message:String) {
		let userInfo = [ NSLocalizedDescriptionKey:message ]

		super.init(domain:"SMJobKit", code:code.rawValue, userInfo:userInfo)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}

func SET_ERROR(error: NSErrorPointer, code: SMJErrorCode, messageFormat: String, arguments: CVarArgType...) {
	if error != nil {
		let message = String(format: messageFormat, arguments: arguments)
		NSLog("[SMJKit Error] %@", message);
		error.memory = SMJError(code:code, message:message)
	}
}
