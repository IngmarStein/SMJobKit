//
//  SMJError.swift
//  SMJobKit
//
//  Created by Ingmar Stein on 29.03.15.
//
//

import Foundation

extension NSError {
	convenience init(code:ErrorCode, message:String) {
		self.init(domain:"SMJobKit", code:code.rawValue, userInfo:[ NSLocalizedDescriptionKey:message ])
	}
}

func SET_ERROR(error: NSErrorPointer, code: ErrorCode, messageFormat: String, arguments: CVarArgType...) {
	if error != nil {
		let message = String(format: messageFormat, arguments: arguments)
		NSLog("[SMJobKit Error] %@", message)
		error.memory = NSError(code:code, message:message)
	}
}
