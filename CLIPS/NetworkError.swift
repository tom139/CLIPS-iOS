//
//  NetworkError.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 21/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

struct NetworkError {
	let code: Int
	let user: String?
	let debug: String?
}

extension NetworkError : CustomStringConvertible {
	var description: String {
		var desc = "[NetworkError] (\(code))"
		if let user = user {
			desc += "\n\t\(user)"
		}
		if let debug = debug {
			desc += "\n\t\(debug)"
		}
		return desc
	}
}
