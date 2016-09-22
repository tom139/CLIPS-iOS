//
//  RequestOperationTest.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 20/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import XCTest
@testable import CLIPS

class RequestOperationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testRequest() {
		let queue = CLIPS.OperationQueue()
		let buildings = BuildingsRequest(latitude: 45, longitude: 11)
		guard let cacheDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
			XCTFail("unable to cast from nil")
			return
		}
		let exp = expectation(description: "operation expectation")
		let cacheFile = cacheDirectory.appendingPathComponent("cache.json")
		print("cacheFile = \(cacheFile)")
		let operation = try! CLIPSRequest(request: buildings, cacheFile: cacheFile)
		let finish = Foundation.BlockOperation {
			FileManager.default.contents(atPath: cacheFile.path)
			do {
				print("contenuto: \(try String(contentsOfFile: cacheFile.path))")
			} catch {
				XCTFail("error \(error)")
			}
			exp.fulfill()
		}
		finish.addDependency(operation)
		queue.addOperation(operation)
		queue.addOperation(finish)
		waitForExpectations(timeout: 10, handler: nil)
	}
		
}
