//
//  BlockObserver.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

struct BlockObserver: OperationObserver {
	
	private let startHandler:   ((Operation) -> Void)?
	private let produceHandler: ((Operation, Foundation.Operation) -> Void)?
	private let finishHandler:  ((Operation, [NSError]) -> Void)?
	
	init(startHandler: ((Operation) -> Void)? = nil,
	     produceHandler: ((Operation, Foundation.Operation) -> Void)? = nil,
	     finishHandler: ((Operation, [NSError]) -> Void)? = nil)
	{
		self.startHandler = startHandler
		self.produceHandler = produceHandler
		self.finishHandler = finishHandler
	}
	
	func operationDidStart(operation: Operation) {
		startHandler?(operation)
	}
	
	func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) {
		produceHandler?(operation, newOperation)
	}
	
	func operationDidFinish(_ operation: Operation, errors: [NSError]) {
		finishHandler?(operation, errors)
	}
}
