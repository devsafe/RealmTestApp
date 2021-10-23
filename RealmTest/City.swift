//
//  City.swift
//  RealmTest
//
//  Created by Boris Sobolev on 23.10.2021.
//

import Foundation
import RealmSwift

class City: Object {
	@objc dynamic var name = ""
	@objc dynamic var code = 0

	override class func primaryKey() -> String? {
		"name"
	}
}
