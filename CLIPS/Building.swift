//
//  Building.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 20/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

struct Building {
	let title: String
	let description: String
	let target: String
	let otherInfo: String
}

extension Building {
	init?(json: [String:Any]) {
		guard let title = json["title"] as? String,
			let description = json["description"] as? String,
			let target = json["target"] as? String,
			let otherInfo = json["otherInfo"] as? String else {
				return nil
		}
		
		self.init(title: title, description: description, target: target, otherInfo: otherInfo)
	}
}

extension Building: ThreeLabelsDisplayable {
	var head:    String { return title       }
	var subhead: String { return description }
	var detail:  String { return target      }
}
