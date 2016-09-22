//
//  GroupOperation.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

class GroupOperation: Operation {
	fileprivate let internalQueue = OperationQueue()
	fileprivate let startingOperation = Foundation.BlockOperation(block: {})
	fileprivate let finishingOperation = Foundation.BlockOperation(block: {})
	
	fileprivate var aggregatedErrors = [NSError]()
	
	convenience init(operations: Foundation.Operation...) {
		self.init(operations: operations)
	}

	init(operations: [Foundation.Operation]) {
		super.init()
		
		internalQueue.isSuspended = true
		internalQueue.delegate = self
		internalQueue.addOperation(startingOperation)
		
		for operation in operations {
			internalQueue.addOperation(operation)
		}
	}
	
	override func cancel() {
		internalQueue.cancelAllOperations()
		super.cancel()
	}
	
	override func execute() {
		internalQueue.isSuspended = false
		internalQueue.addOperation(finishingOperation)
	}
	
	func addOperation(_ operation:Foundation.Operation) {
		internalQueue.addOperation(operation)
	}
	
	final func aggregateError(error: NSError) {
		aggregatedErrors.append(error)
	}
	
	func operationDidFinish(operation: Foundation.Operation, with errors: [NSError]) {
		
	}
}

extension GroupOperation: OperationQueueDelegate {
	final func operationQueue(_ operationQueue: OperationQueue, willAdd operation: Foundation.Operation) {
		assert(!finishingOperation.isFinished && !finishingOperation.isExecuting, "cannot add new operations to a group after the group has completed.")
		
		if operation !== finishingOperation {
			finishingOperation.addDependency(operation)
		}
		
		if operation !== startingOperation {
			operation.addDependency(startingOperation)
		}
	}
	
	final func operationQueue(_ operationQueue: OperationQueue, didFinish operation: Foundation.Operation, with errors: [NSError]) {
		aggregatedErrors.append(contentsOf: errors)
		
		if operation === finishingOperation {
			internalQueue.isSuspended = true
			finish(errors: aggregatedErrors)
		} else if operation !== startingOperation {
			operationDidFinish(operation: operation, with: errors)
		}
	}
}
