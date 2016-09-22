//
//  URLSessionTaskOperation.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

private var URLSessionTaskOperationKVOContext = 0

class URLSessionTaskOperation : Operation {
	let task : URLSessionTask
	
	init(task: URLSessionTask) {
		assert(task.state == .suspended, "Task must be suspended on `URLSessionTaskOperation.init(task:).")
		self.task = task
	}
	
	override func execute() {
		assert(task.state == .suspended, "Task was resumed by something other than \(self).")
		task.addObserver(self, forKeyPath: "state", options: [], context: &URLSessionTaskOperationKVOContext)
		task.resume()
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard context == &URLSessionTaskOperationKVOContext else {
			return
		}
		
		if let o = object as? URLSessionTask, o === task && keyPath == "state" && task.state == .completed {
			task.removeObserver(self, forKeyPath: "state")
			finish()
		}
	}
	
	override func cancel() {
		task.cancel()
		super.cancel()
	}
}
