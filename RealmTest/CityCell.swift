//
//  CityCell.swift
//  RealmTest
//
//  Created by Boris Sobolev on 23.10.2021.
//

import UIKit

class CityCell: UITableViewCell {

	@IBOutlet var name: UILabel!
	@IBOutlet var code: UILabel!

	func configure(_ city: City) {
		name.text = city.name
		code.text = String(city.code)
	}
}
