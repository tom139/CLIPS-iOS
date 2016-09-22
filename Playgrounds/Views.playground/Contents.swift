//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class Button : UIView {
	let size = CGSize(width: 100, height: 30)
	var text = "PressMe"
	var textColor = UIColor.white
	let cornerRadius : CGFloat = 12
	
	let loadedColor : UIColor = .purple
	let loadingColor: UIColor = UIColor.purple.withAlphaComponent(0.6)
	
	override func awakeFromNib() {
		layer.cornerRadius = cornerRadius
		layer.masksToBounds = true
		setupSubviews()
	}
	
	let loadingView = UIView()
	
	func setupSubviews() {
		NSLayoutConstraint.deactivate(constraints)
		subviewsContraints = []
		
		loadingView.backgroundColor = loadedColor
		subviewsContraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[l]|", options: [], metrics: nil, views: ["l":loadingView])
		subviewsContraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[l]|", options: [], metrics: nil, views: ["l":loadingView])
		addSubview(loadingView)
		
		print("ciao")
		
		NSLayoutConstraint.activate(constraints)
	}
	
	var subviewsContraints: [NSLayoutConstraint] = []
}

let b = Button(frame: CGRect(x: 0, y: 0, width: 100, height: 30))

PlaygroundPage.current.liveView = b
