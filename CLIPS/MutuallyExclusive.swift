//
//  MutuallyExclusive.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

struct MutuallyExclusive<T>: OperationCondition {
	
	static var name: String {
		return "MutuallyExclusive<\(T.self)>"
	}
	
	static var isMutuallyExclusive: Bool {
		return true
	}
	
	init() {}
	
	func dependency(for operation: Operation) -> Foundation.Operation? {
		return nil
	}
	
	func evaluate(for operation: Operation, completion: (OperationConditionResult) -> Void) {
		completion(.satisfied)
	}
}

enum Alert {}

typealias AlertPresentation = MutuallyExclusive<Alert>
