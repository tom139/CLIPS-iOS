//
//  OperationQueue.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

@objc protocol OperationQueueDelegate : NSObjectProtocol {
	@objc optional func operationQueue(_ operationQueue: OperationQueue, willAdd operation: Foundation.Operation)
	@objc optional func operationQueue(_ operationQueue: OperationQueue, didFinish operation: Foundation.Operation, with errors: [NSError])
}

class OperationQueue : Foundation.OperationQueue {
	
	weak var delegate : OperationQueueDelegate?
	
	override func addOperation(_ operation: Foundation.Operation) {
		if let op = operation as? Operation {
			let delegate = BlockObserver(startHandler: nil,
			                             produceHandler: { [weak self] (op, new) in
											self?.addOperation(new)
										 },
			                             finishHandler: { [weak self] (op, errors) in
											if let q = self {
												q.delegate?.operationQueue?(q, didFinish: op, with: errors)
											}
										 })
			op.add(observer: delegate)
			
			let dependencies = op.conditions.flatMap {
				$0.dependency(for: op)
			}
			
			for dependency in dependencies {
				op.addDependency(dependency)
				self.addOperation(dependency)
			}
			
			let concurrencyCategories: [String] = op.conditions.flatMap { condition in
				if !type(of: condition).isMutuallyExclusive {
					return nil
				}
				return "\(type(of: condition))"
			}
			
			if !concurrencyCategories.isEmpty {
				let exclusivityController = ExclusivityController.shared
				exclusivityController.add(operation: op, categories: concurrencyCategories)
				op.add(observer: BlockObserver { operation, _ in
					exclusivityController.remove(operation: operation, categories: concurrencyCategories)
				})
			}
			
			op.willEnqueue()
		} else {
			operation.completionBlock = { [weak self, weak operation] in
				guard let queue = self, let operation = operation else {
					return
				}
				queue.delegate?.operationQueue?(queue, didFinish: operation, with: [])
			}
		}
		delegate?.operationQueue?(self, willAdd: operation)
		super.addOperation(operation)
	}
	
	override func addOperations(_ ops: [Foundation.Operation], waitUntilFinished wait: Bool) {
		for operation in operations {
			addOperation(operation)
		}
		
		if wait {
			for operation in operations {
				operation.waitUntilFinished()
			}
		}
	}
}
