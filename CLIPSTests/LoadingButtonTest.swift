//
//  LoadingButtonTest.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 14/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import XCTest
@testable import CLIPS

class LoadingButtonTest: XCTestCase {
    
	func testInit() {
		_ = LoadingButton.initFromStoryboard()
	}
	
	func testInitialState() {
		let b = LoadingButton.initFromStoryboard()
		switch b.state {
		case .normal:
			break
		default:
			XCTFail("initial state should be .normal")
		}
	}
	
	func testLoadingBarChange() {
		let b = LoadingButton.initFromStoryboard()
		
		for _ in 0..<2 {
			
			b.setState(state: .normal)
			XCTAssertEqual(b.percentage, 1.0)
			
			b.setState(state: .pressed)
			XCTAssertEqual(b.percentage, 0.0)
			
			for i in 0...10 {
				let p : Float = Float(i) / 10
				b.setState(state: .loading(percentage: p))
				XCTAssertEqualWithAccuracy(b.percentage, p, accuracy: 0.01)
			}
		}
	}
}
