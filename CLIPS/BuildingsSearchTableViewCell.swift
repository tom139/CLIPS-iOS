//
//  BuildingsSearchTableViewCell.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 14/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import UIKit

protocol BuildingSearchTableViewCellDelegate : class {
	func search(within radius: Int)
}

class BuildingsSearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        radius = 50
		setupSearchButton()
    }

	@IBOutlet weak var radiusLabel: UILabel!
	@IBOutlet weak var radiusSlider: UISlider!
	@IBAction func radiusSliderDidChange(_ sender: UISlider) {
		radius = Int(sender.value)
	}
	var radius = 50 {
		didSet {
			radiusLabel.text = "entro un raggio di \(radius) km"
			radiusSlider.value = Float(radius)
		}
	}
	
	@IBOutlet weak var searchButtonContainer: UIView!
	var searchButton : LoadingButton!
	var searchButtonTap: UITapGestureRecognizer!
	
	func setupSearchButton() {
		searchButton = LoadingButton.initFromStoryboard()
		searchButton.title = "Cerca"
		searchButton.setState(state: .normal)
		searchButtonContainer.addSubview(searchButton)
		let cc : [NSLayoutConstraint] = [
			searchButton.leadingAnchor.constraint(equalTo: searchButtonContainer.leadingAnchor),
			searchButton.trailingAnchor.constraint(equalTo: searchButtonContainer.trailingAnchor),
			searchButton.topAnchor.constraint(equalTo: searchButtonContainer.topAnchor),
			searchButton.bottomAnchor.constraint(equalTo: searchButtonContainer.bottomAnchor)
		]
		NSLayoutConstraint.activate(cc)
	}
	
	func didTapSearchButton() {
		searchButton.setState(state: .pressed)
	}
}
