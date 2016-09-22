//
//  LoginViewController.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 13/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.state = RegistrationState()
		setupScrollView()
		setupLoadingButton()
	}
	
	enum State {
		case login, registration, waitForAuthentication
	}
	
	var state : LoginViewControllerState = RegistrationState() {
		didSet {
			showHide(state: state.viewState)
			updateTitles(state: state)
		}
	}

	/// global items
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	
	/// common items
	@IBOutlet weak var email: UIStackView!
	@IBOutlet weak var emailTxt: UITextField!
	@IBOutlet weak var password: UIStackView!
	@IBOutlet weak var passwordTxt: UITextField!
	
	
	/// registration items
	@IBOutlet weak var username: UIStackView!
	@IBOutlet weak var usernameTxt: UITextField!
	@IBOutlet weak var password2: UIStackView!
	@IBOutlet weak var password2Txt: UITextField!
	
	/// login items
	@IBOutlet weak var forgotPassword: UIButton!
	
	/// login/registration switch
	@IBOutlet weak var loginRegSegControl: UISegmentedControl!
	@IBAction func loginRegSegControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			state = RegistrationState()
		case 1:
			state = LoginState()
		default: fatalError("unknown index")
		}
	}
	
	// bottom button
	var loadingButton: LoadingButton!
	var loadingButtonTap: UITapGestureRecognizer!
	@IBOutlet weak var bottomButtonContainer: UIView! {
		didSet {
			let button = LoadingButton.initFromStoryboard()
			bottomButtonContainer.addSubview(button)
			let cc : [NSLayoutConstraint] = [
				button.bottomAnchor.constraint(equalTo: bottomButtonContainer.bottomAnchor),
				button.leadingAnchor.constraint(equalTo: bottomButtonContainer.leadingAnchor),
				button.trailingAnchor.constraint(equalTo: bottomButtonContainer.trailingAnchor),
				button.topAnchor.constraint(equalTo: bottomButtonContainer.topAnchor)
			]
			NSLayoutConstraint.activate(cc)
			loadingButton = button
		}
	}
	
	
	// handle UI transitions
	func showHide(state: State, animated: Bool = true) {
		
		var visibleItems: [UIView] = [stackView, email, password]
		var hiddenItems : [UIView] = []
		
		switch state {
		case .login:
			visibleItems += [forgotPassword]
			hiddenItems += [password2, username]
		case .registration:
			visibleItems += [password2, username]
			hiddenItems += [forgotPassword]
		case .waitForAuthentication:
			// don't know if i was in login or registration state
			break
		}
		
		for hidden in hiddenItems {
			hidden.isHidden = true
		}
		for visible in visibleItems {
			visible.isHidden = false
		}
		
		
//		let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
//			for hidden in hiddenItems {
//				hidden.alpha = 0.0
//			}
//		}
//		
//		animator.addAnimations({
//			for visible in visibleItems {
//				visible.alpha = 1.0
//				visible.isHidden = false
//			}
//		}, delayFactor: 0.3)
//		
//		animator.addAnimations({
//			for hidden in hiddenItems {
//				hidden.isHidden = true
//			}
//		}, delayFactor: 0.6)
//		
//		animator.startAnimation()
	}
	
	func updateTitles(state: LoginViewControllerState) {
		if let title = state.buttonTitle {
			loadingButton.title = title
		}
		if let title = state.title {
			titleLabel.text = title
		}
	}
	
	// scrollView handling
	func setupScrollView() {
		let stackViewVerticalSpace   : CGFloat = 20
		let stackViewHorizontalSpace : CGFloat = 20
		let size = CGSize(width: view.bounds.width, height: stackView.frame.height + 2 * stackViewVerticalSpace)
		let cc : [NSLayoutConstraint] = [
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: stackViewHorizontalSpace),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: stackViewHorizontalSpace),
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: stackViewVerticalSpace),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: stackViewVerticalSpace)
		]
		scrollView.contentSize = size
		scrollView.addSubview(stackView)
		NSLayoutConstraint.activate(cc)
	}
	
	func setupLoadingButton() {
		loadingButton.setState(state: .normal, duration: 0)
		loadingButtonTap = UITapGestureRecognizer(target: self, action: #selector(loadingButtonPressed))
		loadingButton.addGestureRecognizer(loadingButtonTap)
	}
	
	func loadingButtonPressed() {
//		loadingButton.setState(state: .loading(percentage: 0.0), duration: 0.0)
//		loadingButton.setState(state: .loading(percentage: 0.8), duration: 3.0)
		loadingButton.setState(state: .pressed, duration: 0)
	}
}

protocol LoginViewControllerState {
	var identifier : String  { get }
	var title      : String? { get }
	var buttonTitle: String? { get }
	var loadingButtonState: LoadingButton.State { get set }
	var viewState  : LoginViewController.State { get }
}

struct RegistrationState : LoginViewControllerState {
	var identifier: String {
		return "Registration"
	}
	var title: String? {
		return "Registrati"
	}
	var buttonTitle: String? {
		return title
	}
	var loadingButtonState: LoadingButton.State = .normal
	var viewState : LoginViewController.State {
		return .registration
	}
}

struct LoginState : LoginViewControllerState {
	var identifier: String {
		return "Login"
	}
	var title: String? {
		return "Accedi"
	}
	var buttonTitle: String? {
		return title
	}
	var loadingButtonState: LoadingButton.State = .normal
	var viewState : LoginViewController.State {
		return .login
	}
}
