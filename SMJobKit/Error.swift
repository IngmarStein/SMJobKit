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
