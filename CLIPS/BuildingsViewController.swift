//
//  BuildingsViewController.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 14/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import UIKit

class BuildingsViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.dataSource = self
		}
	}
	var items : [ThreeLabelsDisplayable] = []
	let operationQueue = OperationQueue()
}

extension BuildingsViewController : UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2 + items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : UITableViewCell
		switch indexPath.item {
		case 0:
			cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
		case 1:
			cell = tableView.dequeueReusableCell(withIdentifier: "BuildingSearchCell", for: indexPath)
		default:
			let c = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as! ThreeLabelsTableViewCell
			c.state = items[indexPath.item - 2]
			cell = c
		}
		return cell
	}
}

extension BuildingsViewController: BuildingSearchTableViewCellDelegate {
	func search(within radius: Int) {
//		let operation = CLIPS
	}
}
