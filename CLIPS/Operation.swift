//
//  Operation.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

class Operation : Foundation.Operation {
	
	class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
		return ["state" as NSObject]
	}
	
	class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
		return ["state" as NSObject]
	}
	
	class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
		return ["state" as NSObject]
	}
	
	// MARK: Staate Management
	
	fileprivate enum State: Int, Comparable {
		case initialized, pending, evaluatingConditions, ready, executing, finishing, finished
		func canTransition(toState target: State) -> Bool {
			switch (self, target) {
			case (.initialized, .pending): return true
			case (.pending, .evaluatingConditions): return true
			case (.evaluatingConditions, .ready): return true
			case (.ready, .executing): return true
			case (.ready, .finishing): return true
			case (.executing, .finishing): return true
			case (.finishing, .finished): return true
			default: return false
			}
		}
	}
	
	func willEnqueue() {
		state = .pending
	}
	
	private var _state = State.initialized
	private let stateLock = NSLock()
	private var state  : State {
		get {
			return stateLock.withCriticalScope {
				_state
			}
		}
		set (newState) {
			willChangeValue(forKey: "state")
			stateLock.withCriticalScope {
				guard _state != .finished else {
					return
				}
				assert(_state.canTransition(toState: newState), "Performing invalid state transition.")
				_state = newState
			}
			
			didChangeValue(forKey: "state")
		}
	}
	
	override var isReady: Bool {
		switch state {
		case .initialized: return isCancelled
		case .pending:
			guard !isCancelled else {
				return true
			}
			if super.isReady {
				evaluateConditions()
			}
			return false
		case .ready: return super.isReady || isCancelled
		default: return false
		}
	}
	
	var userInitiated : Bool {
		get {
			return qualityOfService == .userInitiated
		}
		set {
			assert(state < .executing, "Cannot modify userInitiated after execution has begun.")
			qualityOfService = newValue ? .userInitiated : .default
		}
	}
	
	override var isExecuting: Bool {
		return state == .executing
	}
	
	override var isFinished: Bool {
		return state == .finished
	}
	
	private func evaluateConditions() {
		assert(state == .pending && !isCancelled, "evaluateConditions() was called out-of-order")
		state = .evaluatingConditions
		OperationConditionEvaluator.evaluate(conditions: conditions, operation: self) { (failures) in
			self._internalErrors.append(contentsOf: failures)
			self.state = .ready
		}
	}
	
	// MARK: Observers and conditions
	
	private(set) var conditions = [OperationCondition]()
	
	func add(condition: OperationCondition) {
		assert(state < .evaluatingConditions, "Cannot modify conditions after execution has begun.")
		conditions.append(condition)
	}
	
	private(set) var observers = [OperationObserver]()
	
	func add(observer: OperationObserver) {
		assert(state < .executing, "Cannot modify observers after execution has begun.")
		observers.append(observer)
	}
	
	override func addDependency(_ op: Foundation.Operation) {
		assert(state < .executing, "Dependencies cannot be modified after execution has begun.")
		super.addDependency(op)
	}
	
	// MARK: execution and cancellation
	
	override func start() {
		super.start()
		if isCancelled {
			finish()
		}
	}
	
	override func main() {
		assert(state == .ready, "This operation must be performed on an operation queue.")
		
		if _internalErrors.isEmpty && !isCancelled {
			state = .executing
			
			for observer in observers {
				observer.operationDidStart(operation: self)
			}
			
			execute()
		} else {
			finish()
		}
	}
	
	func execute() {
		print("\(type(of: self)) must override `execute()`.")
		finish()
	}
	
	private var _internalErrors = [NSError]()
	func cancel(with error: NSError? = nil) {
		if let error = error {
			_internalErrors.append(error)
		}
		cancel()
	}
	
	final func produce(operation: Foundation.Operation) {
		for observer in observers {
			observer.operation(self, didProduceOperation: operation)
		}
	}
	
	final func finish(with error: NSError?) {
		if let error = error {
			finish(errors: [error])
		} else {
			finish()
		}
	}
	
	private var hasFinishedAlready = false
	final func finish(errors: [NSError] = []) {
		if !hasFinishedAlready {
			hasFinishedAlready = true
			state = .finishing
			let combinedErrors = _internalErrors + errors
			finished(errors: combinedErrors)
			
			for observer in observers {
				observer.operationDidFinish(self, errors: combinedErrors)
			}
			
			state = .finished
		}
	}
	
	func finished(errors: [NSError]) {
		
	}
	
	override func waitUntilFinished() {
		fatalError("Waiting on operations is an anti-pattern")
	}
}

fileprivate func <(lhs: Operation.State, rhs: Operation.State) -> Bool {
	return lhs.rawValue < rhs.rawValue
}

fileprivate func ==(lhs: Operation.State, rhs: Operation.State) -> Bool {
	return lhs.rawValue == rhs.rawValue
}

extension NSLock {
	func withCriticalScope<T>(block: (Void) -> T) -> T {
		lock()
		let value = block()
		unlock()
		return value
	}
}
