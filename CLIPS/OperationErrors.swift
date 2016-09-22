//
//  OperationErrors.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

let OperationErrorDomain = "OperationErrors"

enum OperationErrorCode: Int {
	case conditionFailed = 1
	case executionFailed = 2
}

extension NSError {
	convenience init(code: OperationErrorCode, userInfo: [NSObject: AnyObject]? = nil) {
		self.init(domain: OperationErrorDomain, code: code.rawValue, userInfo: userInfo)
	}
}

// This makes it easy to compare an `NSError.code` to an `OperationErrorCode`.
func ==(lhs: Int, rhs: OperationErrorCode) -> Bool {
	return lhs == rhs.rawValue
}

func ==(lhs: OperationErrorCode, rhs: Int) -> Bool {
	return lhs.rawValue == rhs
}
