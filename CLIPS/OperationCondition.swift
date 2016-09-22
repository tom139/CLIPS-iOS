//
//  OperationCondition.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

let OperationConditionKey = "OperationCondition"

protocol OperationCondition {
	static var name : String { get }
	static var isMutuallyExclusive: Bool { get }
	func dependency(for operation: Operation) -> Foundation.Operation?
	func evaluate(for operation: Operation, completion: (OperationConditionResult) -> Void)
}

enum OperationConditionResult: Equatable {
	case satisfied, failed(NSError)
	var error: NSError? {
		if case .failed(let error) = self {
			return error
		} else {
			return nil
		}
	}
}

func ==(lhs: OperationConditionResult, rhs: OperationConditionResult) -> Bool {
	switch (lhs, rhs) {
	case (.satisfied, .satisfied): return true
	case (.failed(let lError), .failed(let rError)) where lError == rError: return true
	default: return false
	}
}

struct OperationConditionEvaluator {
	static func evaluate(conditions: [OperationCondition], operation: Operation, completion: @escaping ([NSError]) -> Void) {
		let conditionGroup = DispatchGroup()
		var results = [OperationConditionResult?](repeating: nil, count: conditions.count)
		for (index, condition) in conditions.enumerated() {
			conditionGroup.enter()
			condition.evaluate(for: operation) { (result) in
				results[index] = result
				conditionGroup.leave()
			}
		}
		
		conditionGroup.notify(queue: DispatchQueue.global()) { 
			var failures = results.flatMap { $0?.error }
			if operation.isCancelled {
				failures.append(NSError(code: .conditionFailed))
			}
			completion(failures)
		}
	}
}
