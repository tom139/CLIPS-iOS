//
//  LoadingButton.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 14/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import UIKit

class LoadingButton: UIView {
	
	enum State {
		case normal, pressed, loading(percentage: Float)
	}
	
	private (set) var state : State = .normal
	
	private(set) var percentage: Float = 1

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var loadedView: UIView!
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var loadingViewWidth: NSLayoutConstraint!
	
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = title.uppercased()
		}
	}
	
	override func awakeFromNib() {
		backgroundView.layer.cornerRadius = 10.0
		backgroundView.layer.masksToBounds = true
		translatesAutoresizingMaskIntoConstraints = false
		state = .normal
	}
	
	public var title : String = "Title" {
		didSet {
			titleLabel.text = title.uppercased()
		}
	}

	public class func initFromStoryboard() -> LoadingButton {
		let nib = UINib(nibName: "LoadingButton", bundle: nil)
		let views = nib.instantiate(withOwner: nil, options: nil)
		let button = views[0] as! LoadingButton
		return button
	}
	
	public func setState(state: State, duration: TimeInterval = 0.0) {
		self.state = state
		updateLoadingBar(state: state, duration: duration)
	}
	
	func updateLoadingBar(state: State, duration: TimeInterval = 0) {
		let multiplier: Float
		switch state {
		case .normal: multiplier = 0
		case .pressed: multiplier = 1
		case .loading(percentage: let p): multiplier = 1.0 - p
		}
		
		let width : CGFloat = loadedView.bounds.width * CGFloat(multiplier)
		loadingViewWidth.constant = width
		
		percentage = 1-multiplier
		
		UIView.animate(withDuration: duration) {
			self.setNeedsUpdateConstraints()
			self.updateConstraintsIfNeeded()
		}
	}
}
