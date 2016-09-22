//
//  ExclusivityController.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

class ExclusivityController {
	static let shared = ExclusivityController()
	
	private let serialQueue = DispatchQueue(label: "Operations.ExclusivityController",
	                                        qos: .default,
	                                        attributes: [],
	                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
	                                        target: nil)
	private var operations: [String: [Operation]] = [:]
	
	private init() {}
	
	func add(operation : Operation, categories: [String]) {
		serialQueue.sync {
			for category in categories {
				self.noqueue_add(operation: operation, category: category)
			}
		}
	}
	
	func remove(operation: Operation, categories: [String]) {
		serialQueue.sync {
			for category in categories {
				self.noqueue_remove(operation: operation, category: category)
			}
		}
	}
	
	private func noqueue_add(operation: Operation, category: String) {
		var operationsWithThisCategory = operations[category] ?? []
		if let last = operationsWithThisCategory.last {
			operation.addDependency(last)
		}
		operationsWithThisCategory.append(operation)
		operations[category] = operationsWithThisCategory
	}
	
	private func noqueue_remove(operation: Operation, category: String) {
		let matchingOperations = operations[category]
		if var operationsWithThisCategory = matchingOperations, let index = operationsWithThisCategory.index(of: operation) {
			operationsWithThisCategory.remove(at: index)
			operations[category] = operationsWithThisCategory
		}
	}
}
