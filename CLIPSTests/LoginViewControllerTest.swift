//
//  LoginViewControllerTest.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 13/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import XCTest
@testable import CLIPS

class LoginViewControllerTest: XCTestCase {

	var vc : LoginViewController!

	override func setUp() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
		_ = vc.view
	}

	func testOutlets() {
		/// global stackView
		XCTAssertNotNil(vc.stackView as? UIStackView, "nil")

		/// common items
		XCTAssertNotNil(vc.email as? UIStackView)
		XCTAssertNotNil(vc.emailTxt as? UITextField)
		XCTAssertNotNil(vc.password as? UIStackView)
		XCTAssertNotNil(vc.passwordTxt as? UITextField)


		/// registration items
		XCTAssertNotNil(vc.username as? UIStackView)
		XCTAssertNotNil(vc.usernameTxt as? UITextField)
		XCTAssertNotNil(vc.password2 as? UIStackView)
		XCTAssertNotNil(vc.password2Txt as? UITextField)

		/// login items
		XCTAssertNotNil(vc.forgotPassword as? UIButton)
		
		/// login / registration segmented control
		XCTAssertNotNil(vc.loginRegSegControl as? UISegmentedControl)
	}
	
	func testInitialState() {
		if !(vc.state is RegistrationState) {
			XCTFail("intial state should be registration")
		}
		checkState(state: .registration)
	}
	
	func testStateTransitions() {
		vc.state = RegistrationState()
		checkState(state: .registration)
//		vc.state = .waitForAuthentication
//		checkState(state: .waitForAuthentication)
		vc.state = LoginState()
		checkState(state: .login)
		vc.state = RegistrationState()
		checkState(state: .registration)
	}
	
	func checkState(state: LoginViewController.State, line : UInt = #line) {
		var visibleItems: [UIView] = [vc.stackView, vc.email, vc.password]
		var hiddenItems : [UIView] = []
		
		switch state {
		case .login:
			visibleItems += [vc.forgotPassword]
			hiddenItems += [vc.password2, vc.username]
		case .registration:
			visibleItems += [vc.password2, vc.username]
			hiddenItems += [vc.forgotPassword]
		case .waitForAuthentication:
			// don't know if i was in login or registration state
			break
		}
		
		let exp = expectation(description: "waiting for UI to animate")
		
//		Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
			for visible in visibleItems {
				XCTAssertFalse(visible.isHidden, "\(visible) is Hidden but it shouldn't", line: line)
			}
			for hidden in hiddenItems {
				
				XCTAssertTrue(hidden.isHidden, "\(hidden) is Visible but it shouldn't", line: line)
			}
			exp.fulfill()
//		}
		
//		let queue = DispatchQueue(label: "waiting Queue", qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: .inherit, target: nil)
//		queue.async {
//			sleep(1)
//			for visible in visibleItems {
//				XCTAssertFalse(visible.isHidden, "\(visible) is Hidden but it shouldn't", line: line)
//			}
//			for hidden in hiddenItems {
//				
//				XCTAssertTrue(hidden.isHidden, "\(hidden) is Visible but it shouldn't", line: line)
//			}
//			exp.fulfill()
//		}
		waitForExpectations(timeout: 3, handler: nil)
	}
	
	func testStateChangerSegControl() {
		let sender = UISegmentedControl(items: ["Registrati", "Accedi"])
		for _ in 0..<1 {
			sender.selectedSegmentIndex = 0
			vc.loginRegSegControlChanged(sender)
			XCTAssertTrue(vc.state is RegistrationState)
			sender.selectedSegmentIndex = 1
			vc.loginRegSegControlChanged(sender)
			XCTAssertTrue(vc.state is LoginState)
		}
	}
	
	func testPasswordAreSecure() {
		XCTAssertTrue(vc.passwordTxt.isSecureTextEntry)
		XCTAssertTrue(vc.password2Txt.isSecureTextEntry)
	}
}
