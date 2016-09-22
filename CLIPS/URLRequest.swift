//
//  URLRequest.swift
//  CLIPS
//
//  Created by Tommaso Panozzo on 13/09/16.
//  Copyright © 2016 Beacon Strips. All rights reserved.
//

import Foundation
import CoreLocation

enum URLRequestMethod {
	case get, post(body: [String : Any])
}

protocol BSCURLRequest {
	var baseURL: String { get }
	var path:    String { get }
	var url:     String { get }
	var method:  URLRequestMethod { get }
}

extension BSCURLRequest {
	var baseURL: String { return "http://beaconstrips.tk/api/v1" }
	var url:     String { return baseURL + path }
}

struct BuildingsRequest: BSCURLRequest {
	let latitude: CLLocationDegrees
	let longitude: CLLocationDegrees
	
	var path: String { return "/buildings" }
	var method: URLRequestMethod { return .post(body: body) }
	var body: [String: Any] {
		return ["latitude" : latitude,
				"longitude": longitude,
				"maxResults": 50]
	}
}
