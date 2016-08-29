//
//  RMThemeTableViewController.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/28/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import UIKit

struct Theme {
	var name: String
	var color: UIColor
}

class RMThemeTableViewController: UITableViewController {
	
	// MARK: Properties
	var themes: [Theme] = [
		Theme(name: "Red", color: #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1)),
		Theme(name: "Purple", color: #colorLiteral(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
		Theme(name: "Luna", color: #colorLiteral(red: 0.1991284192, green: 0.6028449535, blue: 0.9592232704, alpha: 1))
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.themes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let themeCell = self.tableView.dequeueReusableCell(withIdentifier: "theme_cell", for: indexPath) as! RMThemeTableViewCell
		themeCell.nameLabel.text = self.themes[indexPath.row].name
		themeCell.themeColorView.backgroundColor = self.themes[indexPath.row].color
		
		return themeCell
	}
	
}
