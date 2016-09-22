//
//  OperationObserver.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

protocol OperationObserver {
	
	/// invocato immediatamente prima del metodo `execute()` di una `Operation`
	func operationDidStart(operation: Operation)
	/// invocato quando viene invocato `Operation.produceOperation(_:)`
	func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation)
	/// invocato quando una `Operation` finisce insieme agli eventuali errori prodotti
	func operationDidFinish(_ operation: Operation, errors: [NSError])
}
