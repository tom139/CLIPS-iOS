//
//  Parsable.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 21/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation

protocol Parsable {
	init?(json: [String: Any])
}

extension Building: Parsable {}
