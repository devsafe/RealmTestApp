//
//  ViewController.swift
//  RealmTest
//
//  Created by Boris Sobolev on 23.10.2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	@IBOutlet var segmentControl: UISegmentedControl!
	@IBOutlet var tableView: UITableView!

	var cityes: Results<City>?
	private var token: NotificationToken?

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		saveData()
		pairTableAndRealm()
		segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
	}

	@objc func segmentChanged(_ segmentControl: UISegmentedControl) {
		switch segmentControl.selectedSegmentIndex {
		case 0:
			cityes = cityes?.sorted(byKeyPath: "name")
			tableView.reloadData()
		case 1:
			cityes = cityes?.sorted(byKeyPath: "code")
			tableView.reloadData()
		default:
			break
		}
	}

	private func pairTableAndRealm() {
		guard let realm = try? Realm() else { return }
		print(realm.configuration.fileURL)
		cityes = realm.objects(City.self).sorted(byKeyPath: "code")
		guard let cityes = cityes else { return }
		token = cityes.observe { [weak self] (changes: RealmCollectionChange) in
			guard let tableView = self?.tableView else { return }
			switch changes {
			case .initial:
				tableView.reloadData()
			case .update(_, let deletions, let insertions, let modifications):
				tableView.beginUpdates()
				tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
									 with: .automatic)
				tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
									 with: .automatic)
				tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
									 with: .automatic)
				tableView.endUpdates()
			case .error(let error):
				fatalError("\(error)")
			}
		}
	}

	func saveData() {
		let newCity = City()
		newCity.name = UUID().uuidString
		newCity.code = Int.random(in: 0...999999)
		do {
			let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
			let realm = try Realm(configuration: config)
			realm.beginWrite()
			realm.add(newCity, update: .all)
			try realm.commitWrite()
		} catch {
			print(error)
		}
	}
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cityes?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as! CityCell
		let city = cityes![indexPath.row]
		cell.configure(city)
		return cell
	}
}
