//
//  CLIPSRequest.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 19/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

class CLIPSRequest: GroupOperation {
	let session: URLSession = .shared
	let cacheFile: URL
	
	init(request: BSCURLRequest, cacheFile: URL) throws {
		self.cacheFile = cacheFile
		super.init(operations: [])
		name = "CLIPS Request"
		
		let urlRequest = try request.getRequest()
		let task = session.downloadTask(with: urlRequest) { [weak self] (url, res, err) in
			self?.downloadFinished(url: url, response: res, error: err)
		}
		
		let taskOperation = URLSessionTaskOperation(task: task)
		addOperation(taskOperation)
	}
	
	func downloadFinished(url: URL?, response: URLResponse?, error: Error?) -> Void {
		if let localURL = url {
			do {
				try? FileManager.default.removeItem(at: cacheFile)
				try FileManager.default.moveItem(at: localURL, to: cacheFile)
			} catch let error as NSError {
				aggregateError(error: error)
			}
		} else if let error = error as? NSError {
			aggregateError(error: error)
		} else {
			// non serve far nulla, finish viene chiamato automaticamente
		}
	}
}

enum CLIPSRequestError : Error {
	case wrongURL(url: String)
}

extension BSCURLRequest {
	func getRequest() throws -> URLRequest {
		guard let url = URL(string: self.url) else {
			throw CLIPSRequestError.wrongURL(url: self.url)
		}
		var request = URLRequest(url: url)
		switch method {
		case .post(body: let body):
			let data = try JSONSerialization.data(withJSONObject: body, options: [])
			request.httpMethod = "POST"
			request.httpBody   = data
		case .get:
			request.httpMethod = "GET"
		}
		return request
	}
}
